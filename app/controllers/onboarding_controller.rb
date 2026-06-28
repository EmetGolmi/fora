# OnboardingController
#
# Wires the six-step /join wizard to the database.
# All JSON endpoints so the client-side step UX stays intact.
#
# Step layout (matches mockup s0–s5):
#   s0  Welcome           — static, no server call
#   s1  Who you are       → POST   /join/account
#   s2  ◯ Temple          → PATCH  /join/temple
#   s3  △ Forum           → PATCH  /join/forum
#                           GET    /join/resolve   (civic-card polling)
#   s4  ▢ Market          → PATCH  /join/market
#   s5  Done              → POST   /join/complete  → redirect dashboard
#
# INVARIANTS enforced here (not just in the DB):
#   • residency_verified is never accepted as a param — set only by the
#     verification-completion flow after a postcard/ID check completes.
#   • users.verified defaults false — set separately (future email confirm).
#   • No param, column, or log line captures citizenship or immigration status.
#     service_status captures military service (active/veteran) only.
#   • temple_scale_tradition stores the sources-breadth scalar (1–5).
#     faith_tradition is a separate optional string, not a scale.
#   • No drivers field exists or is accepted anywhere.
#   • service_summary is reused as the day's-work field:
#     free-text description of work → feeds NAICS categorisation and the guide.

class OnboardingController < ApplicationController
  layout false

  before_action :require_onboarding_session,
                only: %i[temple forum market complete resolve_status]

  # ── GET /join ───────────────────────────────────────────────────────────────
  # Renders the wizard.  If a session[:user_id] exists with an incomplete
  # profile, passes @start_step so JS can resume at the right section.
  def show
    if current_user
      profile = current_user.civic_profile
      if profile&.onboarding_complete?
        return redirect_to dashboard_path
      end
      @start_step = profile&.onboarding_step.to_i
      @start_step = 1 if @start_step < 1   # clamp: never resume to Welcome
    else
      @start_step = 0
    end
  end

  # ── POST /join/account ──────────────────────────────────────────────────────
  # Step 1.  Creates User + CivicProfile, fires ResolveAddressJob, sets session.
  # Returns JSON { ok: true, step: 2 } or { errors: [...] }.
  def account
    email    = params.dig(:user, :email).to_s.strip.downcase
    password = params.dig(:user, :password).to_s
    handle   = params.dig(:user, :handle).to_s.strip

    addr_line  = params.dig(:profile, :address_line1).to_s.strip
    addr_city  = params.dig(:profile, :address_city).to_s.strip
    addr_state = params.dig(:profile, :address_state).to_s.strip
    show_photo = cast_bool(params.dig(:profile, :show_photo), default: false)

    ActiveRecord::Base.transaction do
      @user = User.create!(email: email, password: password, handle: handle)

      full_address = [ addr_line, addr_city, addr_state ].reject(&:blank?).join(", ")
      job_id = SecureRandom.uuid
      Rails.cache.write("address:#{job_id}", full_address, expires_in: 30.minutes)
      ResolveAddressJob.perform_now(full_address, job_id)

      @user.create_civic_profile!(
        address_line1:   addr_line,
        address_city:    addr_city,
        address_state:   addr_state,
        place_label:     [ addr_city, addr_state ].reject(&:blank?).join(", "),
        show_photo:      show_photo,
        resolve_job_id:  job_id,
        onboarding_step: 2
        # residency_verified intentionally absent — defaults false in DB
      )

      session[:user_id] = @user.id
    end

    render json: { ok: true, step: 2 }

  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  # ── PATCH /join/temple ──────────────────────────────────────────────────────
  # Step 2.  Saves the four bipolar scales + grow_areas + optional faith string.
  # temple_scale_tradition = sources-breadth scalar (1–5), NOT a faith selection.
  # faith_tradition = separate optional free string.
  def temple
    t = params.require(:temple).permit(
      :reason_instinct,   # → temple_scale_reason   (1 = reason, 5 = instinct)
      :purpose_comfort,   # → temple_scale_purpose  (1 = purpose, 5 = comfort)
      :balance_grind,     # → temple_scale_balance  (1 = balance, 5 = grind)
      :sources_breadth,   # → temple_scale_tradition (1 = own traditions, 5 = many traditions)
      :faith_tradition,   # optional free string — not a scale
      :faith_branch,
      grow_areas: []      # mind | body | meaning | means
    )

    attrs = {
      temple_scale_reason:    clamp_scale(t[:reason_instinct]),
      temple_scale_purpose:   clamp_scale(t[:purpose_comfort]),
      temple_scale_balance:   clamp_scale(t[:balance_grind]),
      temple_scale_tradition: clamp_scale(t[:sources_breadth]),
      faith_tradition:        t[:faith_tradition].presence,
      faith_branch:           t[:faith_branch].presence,
      grow_chips:             Array(t[:grow_areas]) & CivicProfile::GROW_CHIPS,
      onboarding_step:        3
    }.compact

    profile.update!(attrs)
    render json: { ok: true, step: 3 }

  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  # ── PATCH /join/forum ───────────────────────────────────────────────────────
  # Step 3.  Saves military service status and the chosen residency-verify method.
  #
  # INVARIANTS:
  #   • residency_verified is NOT accepted here — it is only ever set by the
  #     verification-completion flow (future: postcard scan / ID-match callback).
  #   • No citizenship or immigration status is accepted, stored, or logged.
  #     service_status refers exclusively to U.S. military service.
  def forum
    f = params.require(:forum).permit(
      :service_status,          # "active" | "veteran" | "none"
      :residency_verify_method  # "postcard" | "id_match" | nil (method chosen, not verified yet)
    )

    svc = f[:service_status].to_s
    attrs = {
      service_active:          svc == "active",
      service_veteran:         svc == "veteran",
      residency_verify_method: f[:residency_verify_method].presence,
      onboarding_step:         4
      # residency_verified intentionally absent
    }.compact

    profile.update!(attrs)
    render json: { ok: true, step: 4 }

  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  # ── PATCH /join/market ──────────────────────────────────────────────────────
  # Step 4.  Saves day's-work (→ service_summary), NAICS code, care_tags,
  # provider_mode flag, and entity status.
  # service_summary is kept as-is per handoff confirmation: it semantically means
  # "day's-work input feeding NAICS categorisation and the guide."
  def market
    m = params.require(:market).permit(
      :service_summary,   # day's-work text → NAICS / guide; no rename
      :naics_code,
      :provider_mode,
      :has_entity,
      care_tags: []       # home | car | pets | kids | yard | business
    )

    provider = cast_bool(m[:provider_mode], default: false)
    entity   = m[:has_entity].present? ? cast_bool(m[:has_entity]) : nil

    attrs = {
      service_summary: m[:service_summary].presence,
      naics_code:      m[:naics_code].presence,
      provider_mode:   provider,
      has_entity:      entity,
      care_tags:       Array(m[:care_tags]) & CivicProfile::CARE_TAGS,
      onboarding_step: 5
    }.compact

    profile.update!(attrs)

    # Activate provider capability if the flag is set and we have a NAICS code
    if profile.provider_mode? && profile.naics_code.present?
      profession = NAICS_TO_PROFESSION.fetch(profile.naics_code, "general")
      profile.provider_capabilities.find_or_create_by!(profession: profession) do |cap|
        cap.naics_code = profile.naics_code
        cap.status     = :active
      end
    end

    render json: { ok: true, step: 5 }

  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  # ── POST /join/complete ─────────────────────────────────────────────────────
  # Step 5.  Finalises the identity.  Bridges the resolved address into the
  # dashboard session so the user lands on a populated civic home.
  def complete
    profile.update!(onboarding_complete: true)
    session[:dashboard_job_id] = profile.resolve_job_id if profile.resolve_job_id.present?
    render json: { ok: true, redirect: dashboard_path }
  end

  # ── GET /join/resolve ───────────────────────────────────────────────────────
  # Polls the ResolveAddressJob that was fired at Step 1.
  # Called by the Forum step JS as soon as s3 becomes active.
  # Returns { ready: false } until the job completes.
  # Returns { ready: true, place: "Fishtown, Philadelphia, PA", officials: [...] }
  # with a plain-language place label (never district codes or ZIP codes) and
  # up to 6 officials for the civic card.
  def resolve_status
    job_id = profile.resolve_job_id
    return render json: { ready: false } unless job_id.present?

    raw = Rails.cache.read("resolve:#{job_id}") ||
          ResolvedAddress.find_by(job_id: job_id)&.result_json
    return render json: { ready: false } unless raw

    data = JSON.parse(raw, symbolize_names: true)
    jur  = data[:jurisdiction] || {}

    city  = jur[:city].presence  || profile.address_city
    state = jur[:state].presence || profile.address_state
    place = [ city, state ].reject(&:blank?).join(", ")

    # Persist the resolved place label so the done-card is accurate
    profile.update_column(:place_label, place) if place.present? && place != profile.place_label

    officials = Array(jur[:officials]).first(6).map do |o|
      {
        name:  o[:name],
        role:  o[:office].to_s,
        level: classify_level(o[:office].to_s)
      }
    end

    render json: { ready: true, place: place, officials: officials }
  end

  # ────────────────────────────────────────────────────────────────────────────
  private

  def profile
    @profile ||= current_user.civic_profile
  end

  def require_onboarding_session
    return if current_user
    render json: { error: "Session expired — please start over.", redirect: join_path },
           status: :unauthorized
  end

  # Cast loose booleans from JSON (true/false) or form strings ("true"/"1"/"false"/"0").
  def cast_bool(val, default: nil)
    return default if val.nil?
    ActiveModel::Type::Boolean.new.cast(val)
  end

  # Clamp a Likert scale value to 1–5.  Nil stays nil (unanswered is allowed).
  def clamp_scale(val)
    return nil if val.nil?
    val.to_i.clamp(1, 5)
  end

  # Classify an office string as federal / state / local for the civic card grouping.
  def classify_level(office)
    return "federal" if office.match?(/\bU\.?S\.?\b|congress|senate.*federal|president|vice pres/i)
    return "state"   if office.match?(/state|governor|assembly|legislature|senator.*PA|rep.*PA/i)
    "local"
  end

  # Maps NAICS codes (as detected by the NAICS keyword map in JS) to profession slugs.
  # Used to auto-create a ProviderCapability at Step 4 when provider_mode is set.
  # Extend as new trades go live.
  NAICS_TO_PROFESSION = {
    "238320" => "painter",
    "238210" => "electrician",
    "238220" => "plumber",
    "541350" => "home_inspector",
    "621399" => "nurse",
    "611110" => "teacher",
    "541110" => "attorney",
    "722330" => "chef",
    "711510" => "artist"
  }.freeze
end
