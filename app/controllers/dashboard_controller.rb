class DashboardController < ApplicationController
  layout false
  before_action :require_user
  before_action :load_profile

  # ── GET /mvp/dashboard ───────────────────────────────────────────────────────
  def show
    # Address / officials — resolved during onboarding Step 1.
    # Fall back to legacy session[:dashboard_job_id] for any pre-login
    # address lookups that might still exist in the wild.
    job_id = @profile.resolve_job_id.presence || session[:dashboard_job_id]
    load_jurisdiction(job_id)

    # ── CENTER: Following tab ─────────────────────────────────────────────────
    follows = @profile.follows.includes(:followable).order(created_at: :desc)
    @feed   = build_feed(follows)

    # ── CENTER: Your Jurisdictions tab ────────────────────────────────────────
    @jurisdiction_bills  = jurisdiction_bills
    @jurisdiction_issues = jurisdiction_issues

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
  end

  # ── POST /mvp/dashboard/spark ────────────────────────────────────────────────
  # Toggle a Follow (Spark / un-Spark).  Returns JSON so JS can flip button state.
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

  # ── GET /mvp/dashboard/clear ─────────────────────────────────────────────────
  def clear
    session.delete(:dashboard_job_id)
    redirect_to root_path
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

  def load_jurisdiction(job_id)
    @jurisdiction = {}
    @officials    = []
    return unless job_id.present?

    cached = Rails.cache.read("resolve:#{job_id}") ||
             ResolvedAddress.find_by(job_id: job_id)&.result_json
    return unless cached.present?

    data          = JSON.parse(cached, symbolize_names: true)
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

  # Bills for Your Jurisdictions tab: active bills in the user's state,
  # excluding anything they already follow.
  def jurisdiction_bills
    state = @jurisdiction[:state].to_s.presence || @profile.address_state.to_s
    return CivicBill.none if state.blank?

    already = @profile.follows.where(followable_type: "CivicBill").select(:followable_id)
    CivicBill.active
             .where("jurisdiction ILIKE ?", "%#{state.downcase}%")
             .where.not(id: already)
             .order(status_date: :desc)
             .limit(10)
  end

  # Issues for Your Jurisdictions tab: local RCO issues not yet followed.
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

    already = @profile.follows.where(followable_type: "NeighborhoodIssue").select(:followable_id)
    NeighborhoodIssue.where(rco_slug: rco_slugs)
                     .where.not(id: already)
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

  FOLLOWABLE_TYPES = %w[CivicBill NeighborhoodIssue CivicRepresentative].freeze

  def find_followable(type, id)
    return nil unless FOLLOWABLE_TYPES.include?(type.to_s)
    type.to_s.constantize.find_by(id: id)
  end

  def bill_json(b)
    { id: b.id, identifier: b.identifier, title: b.title,
      status: b.status, status_date: b.status_date&.strftime("%b %d, %Y"),
      jurisdiction: b.jurisdiction }
  end
end
