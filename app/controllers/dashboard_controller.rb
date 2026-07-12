class DashboardController < ApplicationController
  layout false
  before_action :require_user
  before_action :load_profile

  # ── GET /mvp/dashboard ───────────────────────────────────────────────────────
  def show
    # Address / officials — profile-first: resolve_job_id is persisted at
    # account creation and is the canonical source.  Session key is a
    # legacy-only fallback for any pre-login anonymous flows.
    load_jurisdiction

    # ── CENTER: Following tab ─────────────────────────────────────────────────
    follows = @profile.follows.includes(:followable).order(created_at: :desc)
    @feed   = build_feed(follows)

    # ── CENTER: Your Jurisdictions tab ────────────────────────────────────────
    @jurisdiction_bills  = jurisdiction_bills
    @jurisdiction_issues = jurisdiction_issues

    # Precompute follow-state sets for jurisdiction tab cards (avoids N+1).
    # Derived from @feed (already loaded) — no extra queries.
    @followed_bill_ids  = @feed.select { |h| h[:type] == "CivicBill" }
                               .map    { |h| h[:item].id }.to_set
    @followed_issue_ids = @feed.select { |h| h[:type] == "NeighborhoodIssue" }
                               .map    { |h| h[:item].id }.to_set

    # ── CENTER: arc state maps (Build / Integrate tray content) ──────────────
    @connection_map = @profile.connections
                              .each_with_object({}) do |c, h|
                                (h["#{c.source_type}:#{c.source_id}"] ||= []) << c
                              end
    @project_list = @profile.projects.order(:title)

    # ── RIGHT: Docket ─────────────────────────────────────────────────────────
    @docket_items = @feed.first(3)

    # ── RIGHT: Representatives ────────────────────────────────────────────────
    @rep_follows = @profile.follows
                           .where(followable_type: "CivicRepresentative")
                           .pluck(:followable_id)
                           .to_set

    @person_follows = @profile.follows
                              .where(followable_type: "Person")
                              .pluck(:followable_id)
                              .to_set

    # ── RIGHT: Constituency meter ─────────────────────────────────────────────
    top_bill    = @feed.find { |h| h[:type] == "CivicBill" }&.dig(:item)
    @meter_bill = top_bill
    @meter_pct  = top_bill ? constituency_pct(top_bill) : nil

    # Arc state: which issues has this user already concurred on?
    @concurred_issues = @profile.issue_concurrences.pluck(:neighborhood_issue_id).to_set

    # Right-rail rep Follow toggles: pre-load CivicRepresentative rows by bioguide_id.
    bio_ids = @officials.filter_map { |o| o.dig(:jurisdiction, :bioguide_id) }
    @rep_by_bioguide = bio_ids.any? ?
      CivicRepresentative
        .where("external_ids->>'bioguide_id' = ANY(ARRAY[?]::text[])", bio_ids)
        .index_by { |r| r.external_ids["bioguide_id"] } : {}

    # Jurisdiction tab: officials that have CivicRepresentative AR records
    # (needed for followability), preserved in API resolution order.
    @jurisdiction_reps = @officials.filter_map do |o|
      @rep_by_bioguide[o.dig(:jurisdiction, :bioguide_id).to_s]
    end

    # ── LEFT NAV: Temple & Forum accordion data ────────────────────────────
    @temple_domains = TempleDomain.includes(:temple_subcategories).order(:position)
    @forum_domains  = ForumDomain.includes(:forum_subcategories).order(:position)

    # Person records for officials without CivicRepresentative (council members, execs).
    # Indexed two ways for robust O(1) lookup despite name-normalization differences:
    #   "office_type/district_number"  — for district council (unique, no name matching)
    #   "last_name_downcase"           — for at-large/executives as fallback
    local_office_types = %w[city_council city_council_at_large mayor managing_director
                             finance_director governor lt_governor council_president]
    @official_persons = {}
    Person.where(office_type: local_office_types).each do |p|
      key = p.district_number.present? ? "#{p.office_type}/#{p.district_number}" : p.last_name.to_s.split.last.to_s.downcase
      @official_persons[key] = p
    end
  end

  # ── POST /mvp/dashboard/spark ────────────────────────────────────────────────
  # Toggle a Follow (Spark / un-Spark).  Returns JSON so JS can flip button state.
  # This is the Follow create/destroy action — a single POST endpoint that
  # creates a Follow if none exists, or destroys it if one does.
  def spark
    followable = find_followable(params[:type], params[:id])
    return render json: { error: "Not found" }, status: :not_found unless followable

    follow = @profile.follows.find_by(followable: followable)
    if follow
      follow.destroy
      render json: { sparked: false, count: followable.follows.count }
    else
      @profile.follows.create!(followable: followable)
      render json: { sparked: true, count: followable.follows.count }
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  # ── POST /mvp/dashboard/build ────────────────────────────────────────────────
  # Create a Connection (Build step).
  # Requires at least one of: target_id or note.
  def build_connection
    source = find_followable(params[:source_type], params[:source_id])
    return render json: { error: "Source not found" }, status: :not_found unless source

    target = params[:target_type].present? && params[:target_id].present? ?
               find_followable(params[:target_type], params[:target_id]) : nil

    conn = @profile.connections.create!(
      source: source,
      target: target,
      note:   params[:note].presence
    )
    render json: { ok: true, connection_id: conn.id }
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  # ── POST /mvp/dashboard/project_add ─────────────────────────────────────────
  # Add a followable item to a project.
  # Pass project_id to add to existing, or title to create a new one.
  def project_add
    item = find_followable(params[:type], params[:id])
    return render json: { error: "Item not found" }, status: :not_found unless item

    project = if params[:project_id].present?
      @profile.projects.find(params[:project_id])
    else
      @profile.projects.create!(title: params[:title].presence || "My project")
    end

    project.project_items.find_or_create_by!(itemable: item)
    render json: { ok: true, project_id: project.id, project_title: project.title }
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  # ── PATCH /mvp/dashboard/service_area ───────────────────────────────────────
  # Save the current user's service area — radius (miles) or polygon (GeoJSON).
  def update_service_area
    if params[:polygon].present?
      poly = JSON.parse(params[:polygon])
      @profile.update!(service_area: { type: "polygon", geojson: poly }, service_radius_mi: nil)
      render json: { ok: true, mode: "polygon" }
    else
      radius = [[params[:radius_mi].to_f, 0.5].max, 50.0].min
      @profile.update!(service_radius_mi: radius, service_area: { type: "radius", miles: radius })
      render json: { ok: true, radius_mi: radius }
    end
  rescue JSON::ParserError
    render json: { ok: false, errors: "Invalid polygon data" }, status: :unprocessable_entity
  rescue ActiveRecord::RecordInvalid => e
    render json: { ok: false, errors: e.message }, status: :unprocessable_entity
  end

  # ── GET /mvp/dashboard/clear ─────────────────────────────────────────────────
  def clear
    session.delete(:dashboard_job_id)
    redirect_to root_path
  end

  # ── GET /mvp/dashboard/reresolve ────────────────────────────────────────────
  # Re-fires address resolution for the current profile. Synchronous so the
  # result is available immediately on the redirect back to the dashboard.
  def reresolve
    address = [@profile.address_line1, @profile.address_city, @profile.address_state]
                .compact_blank.join(", ")
    if address.present?
      job_id = @profile.resolve_job_id.presence || SecureRandom.hex(8)
      begin
        ResolveAddressJob.perform_now(address, job_id)
        @profile.update_column(:resolve_job_id, job_id) unless @profile.resolve_job_id == job_id
      rescue => e
        Rails.logger.error("reresolve failed for profile #{@profile.id}: #{e.message}")
      end
    else
      Rails.logger.warn("reresolve: profile #{@profile.id} has no address stored")
    end
    redirect_to dashboard_path
  end

  # ── GET /mvp/dashboard/jurisdiction_bills ────────────────────────────────────
  # Paginated JSON for infinite-scroll on the Your Jurisdictions tab.
  def jurisdiction_bills
    load_jurisdiction
    offset   = [params[:offset].to_i, 0].max
    per_page = 15

    scope = jurisdiction_bills_scope
    bills     = scope.offset(offset).limit(per_page)
    has_more  = scope.offset(offset + per_page).exists?

    followed = @profile.follows
                       .where(followable_type: "CivicBill", followable_id: bills.map(&:id))
                       .pluck(:followable_id).to_set

    render json: {
      bills:    bills.map { |b| bill_json_full(b, followed.include?(b.id)) },
      has_more: has_more,
      offset:   offset + per_page
    }
  end

  # ── GET /mvp/dashboard/bills ─────────────────────────────────────────────────
  def bills
    view        = params[:view] == "record" ? "record" : "docket"
    offset      = [params[:offset].to_i, 0].max
    date_filter = ["status_date >= ? OR status_date IS NULL", Date.new(2025, 1, 1)]

    scope = if view == "record"
      CivicBill.resolved.where(date_filter)
    else
      CivicBill.active.where(date_filter)
    end.order(status_date: :desc)

    bills    = scope.offset(offset).limit(18)
    has_more = scope.offset(offset + 18).exists?
    render json: { bills: bills.map { |b| bill_json(b) }, has_more: has_more }
  end

  # ── Legacy resolve endpoints (pre-login address-entry flow) ─────────────────
  def resolve
    address = params[:address].to_s.strip
    return render json: { error: "Address is required" }, status: :unprocessable_entity if address.blank?

    job_id = SecureRandom.uuid
    Rails.cache.write("address:#{job_id}", address, expires_in: 10.minutes)
    ResolveAddressJob.perform_later(address, job_id)
    render json: { job_id: job_id }
  end

  def status
    job_id = params[:job_id]
    ready  = Rails.cache.read("resolve:#{job_id}").present? ||
             ResolvedAddress.find_by(job_id: job_id).present?
    render json: { ready: ready }
  end

  def result
    job_id = params[:job_id]
    cached = Rails.cache.read("resolve:#{job_id}") ||
             ResolvedAddress.find_by(job_id: job_id)&.result_json
    return redirect_to root_path if cached.blank?
    session[:dashboard_job_id] = job_id
    redirect_to dashboard_path
  end

  # ────────────────────────────────────────────────────────────────────────────
  private

  def require_user
    return if current_user
    redirect_to new_session_path
  end

  def load_profile
    @profile = current_user.civic_profile
    redirect_to join_path unless @profile&.onboarding_complete?
  end

  # Profile-first jurisdiction loader.  Three-level fallback:
  #   1. profile.resolve_job_id → cache → ResolvedAddress by job_id
  #   2. profile address → ResolvedAddress by address  (handles upsert collision)
  #   3. session[:dashboard_job_id] → legacy pre-login flows
  # Never re-resolves; only reads already-stored results.
  def load_jurisdiction
    @jurisdiction = {}
    @officials    = []

    cached = nil

    # 1 — profile job_id
    job_id = @profile.resolve_job_id.presence
    if job_id.present?
      cached = Rails.cache.read("resolve:#{job_id}") ||
               ResolvedAddress.find_by(job_id: job_id)&.result_json
    end

    # 2 — address fallback (handles job_id staleness from upsert collision)
    if cached.blank? && @profile.address_line1.present?
      full = [@profile.address_line1, @profile.address_city, @profile.address_state]
               .reject(&:blank?).join(", ")
      cached = ResolvedAddress.find_by(address: full)&.result_json
    end

    # 3 — session fallback (legacy anonymous pre-login flows)
    if cached.blank? && session[:dashboard_job_id].present?
      sj     = session[:dashboard_job_id]
      cached = Rails.cache.read("resolve:#{sj}") ||
               ResolvedAddress.find_by(job_id: sj)&.result_json
    end

    # 4 — synchronous self-heal: if nothing was found but the profile has an
    # address, resolve right now and persist so subsequent loads are instant.
    if cached.blank? && @profile.address_line1.present?
      begin
        full    = [@profile.address_line1, @profile.address_city, @profile.address_state]
                    .compact_blank.join(", ")
        job_id  = @profile.resolve_job_id.presence || SecureRandom.hex(8)
        ResolveAddressJob.perform_now(full, job_id)
        @profile.update_column(:resolve_job_id, job_id) unless @profile.resolve_job_id == job_id
        cached  = ResolvedAddress.find_by(job_id: job_id)&.result_json ||
                  Rails.cache.read("resolve:#{job_id}")
      rescue => e
        Rails.logger.warn("DashboardController#load_jurisdiction self-heal failed: #{e.message}")
      end
    end

    return unless cached.present?

    data = JSON.parse(cached, symbolize_names: true)
    return if data[:error].present?   # job failed; don't surface error payload

    @jurisdiction = data[:jurisdiction] || {}
    @officials    = Array(@jurisdiction[:officials])
  end

  # Build the sorted feed array. Each hash carries everything the view needs
  # without extra queries in the template.
  def build_feed(follows)
    follows.filter_map do |f|
      item = f.followable
      next unless item
      {
        follow:  f,
        item:    item,
        type:    f.followable_type,
        pillar:  "f",
        last_at: activity_time(item)
      }
    end.sort_by { |h| -(h[:last_at]&.to_i || 0) }
  end

  def activity_time(item)
    case item
    when CivicBill           then item.status_date&.to_time || item.updated_at
    when NeighborhoodIssue   then item.updated_at
    when CivicRepresentative then item.updated_at
    end
  end

  # Bills for Your Jurisdictions tab — first page (server-rendered).
  # Subsequent pages are loaded via GET /mvp/dashboard/jurisdiction_bills (JSON).
  def jurisdiction_bills
    jurisdiction_bills_scope.limit(15)
  end

  # Issues for Your Jurisdictions tab: local RCO issues.
  # Shows ALL issues for the user's RCOs regardless of follow state.
  def jurisdiction_issues
    lat = @jurisdiction[:lat]
    lng = @jurisdiction[:lng]
    return NeighborhoodIssue.none unless lat.present? && lng.present?
    return NeighborhoodIssue.none unless @jurisdiction[:city].to_s.upcase == "PHILADELPHIA"

    rco_slugs = begin
      PhillyRcoService.for_coordinate(lat, lng).map { |r| r["slug"] }.compact
    rescue StandardError
      []
    end
    return NeighborhoodIssue.none if rco_slugs.empty?

    NeighborhoodIssue.where(rco_slug: rco_slugs)
                     .order(updated_at: :desc)
                     .limit(10)
  end

  # Verified-resident share of Sparks on a bill.
  # Reads residency_verified only — never citizenship or immigration status.
  def constituency_pct(bill)
    total = bill.follows.count
    return nil if total.zero?
    verified = bill.follows
                   .joins("JOIN civic_profiles ON civic_profiles.id = follows.civic_profile_id")
                   .where(civic_profiles: { residency_verified: true })
                   .count
    ((verified.to_f / total) * 100).round
  end

  FOLLOWABLE_TYPES = %w[CivicBill NeighborhoodIssue CivicRepresentative Person].freeze

  def find_followable(type, id)
    return nil unless FOLLOWABLE_TYPES.include?(type.to_s)
    type.to_s.constantize.find_by(id: id)
  end

  def bill_json(b)
    { id: b.id, identifier: b.identifier, title: b.title,
      status: b.status, status_date: b.status_date&.strftime("%b %d, %Y"),
      jurisdiction: b.jurisdiction }
  end

  def bill_json_full(b, sparked = false)
    bill_json(b).merge(
      bill_stage:   b.bill_stage,
      plain_summary: b.plain_summary,
      effects:       Array(b.effects),
      guide_seeded:  b.guide_seeded,
      sit_for:       b.sit_for,
      sit_against:   b.sit_against,
      study_facts:   Array(b.study_facts),
      full_text_url: b.full_text_url,
      sponsors:      Array(b.sponsors).first(1).map { |s| s["name"] || s[:name] }.compact,
      sparked:       sparked,
      follow_count:  b.follows.count
    )
  end

  # Extracted scope so both #show (server-side) and #jurisdiction_bills (JSON) use the same query.
  def jurisdiction_bills_scope
    state = @jurisdiction[:state].to_s.presence || @profile.address_state.to_s
    return CivicBill.none if state.blank?

    city       = @jurisdiction[:city].to_s.downcase
    state_name = case state.upcase
                 when "PA" then "pennsylvania"
                 else state.downcase
                 end

    jurs = ["federal", state_name]
    jurs << "philadelphia" if city == "philadelphia"

    CivicBill.active
             .where(jurisdiction: jurs)
             .order(Arel.sql("status_date DESC NULLS LAST"))
  end
end
