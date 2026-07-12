# CardBuilderController
#
# 6-step wizard that lets providers build their public-facing card on FORA.
# All JSON endpoints so the client-side step UX stays intact.
#
# Step layout:
#   1  Trade & Identity   → PATCH  /card-builder/trade
#   2  Headline & Summary → PATCH  /card-builder/headline
#   3  Portfolio          → POST/PATCH/DELETE /card-builder/portfolio[/:id]
#   4  Service Area       → PATCH  /card-builder/area
#   5  Temple Contribution→ PATCH  /card-builder/temple
#   6  Complete           → GET    /card-builder/complete
#
# Entry points:
#   • After initial onboarding with provider_mode — redirected from OnboardingController#complete
#   • Dashboard CTA for providers with card_builder_complete: false

class CardBuilderController < ApplicationController
  layout false

  before_action :require_provider_mode

  NAICS_TO_PROFESSION = OnboardingController::NAICS_TO_PROFESSION

  CITY_LOCODE = {
    ["philadelphia", "pa"] => "usphl",
    ["new york",     "ny"] => "usnyc",
    ["chicago",      "il"] => "uschi",
    ["los angeles",  "ca"] => "uslax",
    ["houston",      "tx"] => "ushou",
    ["phoenix",      "az"] => "usphx",
    ["san antonio",  "tx"] => "ussat",
    ["san diego",    "ca"] => "ussan",
    ["dallas",       "tx"] => "usdal",
    ["san jose",     "ca"] => "ussjo",
    ["austin",       "tx"] => "usaus",
    ["jacksonville", "fl"] => "usjax",
    ["columbus",     "oh"] => "uscos",
    ["charlotte",    "nc"] => "usclt",
    ["denver",       "co"] => "usden",
    ["seattle",      "wa"] => "ussea",
    ["detroit",      "mi"] => "usdet",
    ["nashville",    "tn"] => "usbna",
    ["boston",       "ma"] => "usbos",
    ["baltimore",    "md"] => "usbal",
    ["atlanta",      "ga"] => "usatl",
    ["miami",        "fl"] => "usmia",
    ["minneapolis",  "mn"] => "usmsp",
    ["portland",     "or"] => "uspdx",
    ["las vegas",    "nv"] => "uslsv",
  }.freeze

  # ── GET /card-builder ─────────────────────────────────────────────────────
  # Resumes at card_builder_step.  Loads portfolio items for step 3 display.
  def show
    @portfolio_items = profile.library_items
                              .where("? = ANY(tags)", "portfolio")
                              .order(created_at: :desc)
  end

  # ── GET /card-builder/check-handle ────────────────────────────────────────
  # Returns { available: bool, handle: slug }.
  # Called debounced from the JS as the user types their business name.
  def check_handle
    raw    = params[:handle].to_s.strip
    handle = slugify(raw)
    taken  = CivicProfile.where(provider_handle: handle)
                         .where.not(id: profile.id)
                         .exists?
    render json: { available: !taken, handle: handle }
  end

  # ── PATCH /card-builder/trade ──────────────────────────────────────────────
  # Step 1: Save provider_handle + naics_code + onet_code + isco_code + locode.
  def trade
    p = params.require(:trade).permit(:business_name, :naics_code, :onet_code, :isco_code)

    handle = slugify(p[:business_name].to_s)
    if handle.blank?
      return render json: { errors: ["Business name can't be blank"] },
                    status: :unprocessable_entity
    end

    taken = CivicProfile.where(provider_handle: handle)
                        .where.not(id: profile.id)
                        .exists?
    if taken
      return render json: { errors: ["That handle is already taken"] },
                    status: :unprocessable_entity
    end

    locode = compute_locode(profile.address_city, profile.address_state)

    profile.update!(
      provider_handle:   handle,
      naics_code:        p[:naics_code].presence  || profile.naics_code,
      onet_code:         p[:onet_code].presence   || profile.onet_code,
      isco_code:         p[:isco_code].presence   || profile.isco_code,
      locode:            locode                   || profile.locode,
      card_builder_step: [1, profile.card_builder_step].max
    )

    # Ensure provider_capability exists for the chosen NAICS
    if profile.naics_code.present?
      profession = NAICS_TO_PROFESSION.fetch(profile.naics_code, "general")
      profile.provider_capabilities.find_or_create_by!(profession: profession) do |cap|
        cap.naics_code = profile.naics_code
        cap.status     = :active
      end
    end

    render json: { ok: true, step: 2, handle: handle, locode: locode }
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  # ── PATCH /card-builder/headline ───────────────────────────────────────────
  # Step 2: Save provider_headline (≤15 words) + service_summary.
  def headline
    p = params.require(:headline).permit(:provider_headline, :service_summary)

    hl = p[:provider_headline].to_s.strip
    word_count = hl.split.size
    if word_count > 15
      return render json: { errors: ["Headline must be 15 words or fewer (#{word_count} used)"] },
                    status: :unprocessable_entity
    end

    profile.update!(
      provider_headline: hl.presence,
      service_summary:   p[:service_summary].presence || profile.service_summary,
      card_builder_step: [2, profile.card_builder_step].max
    )

    render json: { ok: true, step: 3 }
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  # ── POST /card-builder/portfolio ──────────────────────────────────────────
  # Step 3: Add a portfolio item (link or note).
  def add_portfolio
    p = params.require(:portfolio).permit(:item_type, :title, :source_url, :description)

    type = p[:item_type].to_s == "link" ? :link : :note
    item = profile.library_items.create!(
      item_type:   type,
      title:       p[:title].presence || (type == :link ? p[:source_url] : "Note"),
      source_url:  type == :link ? p[:source_url].presence : nil,
      description: type == :note ? p[:description].presence : nil,
      tags:        ["portfolio"],
      visibility:  :public,
      source:      type == :link ? :link : :text
    )

    render json: { ok: true, item: serialize_item(item) }
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  # ── PATCH /card-builder/portfolio/:id ─────────────────────────────────────
  # Toggle visibility on a portfolio item.
  def update_portfolio
    item = profile.library_items.find(params[:id])
    new_vis = item.visibility_public? ? :private : :public
    item.update!(visibility: new_vis)
    render json: { ok: true, visibility: new_vis }
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Not found" }, status: :not_found
  end

  # ── DELETE /card-builder/portfolio/:id ────────────────────────────────────
  def remove_portfolio
    item = profile.library_items.find(params[:id])
    item.destroy!
    render json: { ok: true }
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Not found" }, status: :not_found
  end

  # ── PATCH /card-builder/area ───────────────────────────────────────────────
  # Step 4: Save service area — radius (miles) or polygon (GeoJSON).
  def area
    if params[:polygon].present?
      poly = JSON.parse(params[:polygon])
      profile.update!(
        service_area:      { type: "polygon", geojson: poly },
        service_radius_mi: nil,
        card_builder_step: [4, profile.card_builder_step].max
      )
      render json: { ok: true, step: 5, mode: "polygon" }
    else
      radius = [[params[:radius_mi].to_f, 0.5].max, 50.0].min
      profile.update!(
        service_radius_mi: radius,
        service_area:      { type: "radius", miles: radius },
        card_builder_step: [4, profile.card_builder_step].max
      )
      render json: { ok: true, step: 5, radius_mi: radius }
    end
  rescue JSON::ParserError
    render json: { errors: ["Invalid polygon data"] }, status: :unprocessable_entity
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  # ── PATCH /card-builder/temple ────────────────────────────────────────────
  # Step 5 (optional): Create a temple contribution library item.
  # Pass skip: true to advance without saving.
  def temple_contribution
    if params[:skip].present? && ActiveModel::Type::Boolean.new.cast(params[:skip])
      profile.update!(card_builder_step: [5, profile.card_builder_step].max)
      return render json: { ok: true, step: 6, skipped: true }
    end

    p = params.require(:temple).permit(:title, :description)

    naics_slug = profile.naics_code.present? ?
                   NAICS_TO_PROFESSION.fetch(profile.naics_code, "general") : "general"

    item = profile.library_items.create!(
      item_type:   :note,
      title:       p[:title].presence || "Expert Tip",
      description: p[:description].presence,
      tags:        ["temple", naics_slug],
      visibility:  :public,
      source:      :text
    )

    profile.update!(card_builder_step: [5, profile.card_builder_step].max)

    render json: { ok: true, step: 6, item_id: item.id }
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  # ── GET /card-builder/complete ────────────────────────────────────────────
  # Final step: mark card complete. Called by JS fetch — returns JSON.
  def complete
    profile.update!(card_builder_complete: true, card_builder_step: 6)
    render json: { ok: true, handle: profile.provider_handle }
  end

  # ── POST /card-builder/restart ─────────────────────────────────────────────
  # Resets wizard state so provider can add a new service. Called from
  # "Add a service" button in My Services panel. Existing capabilities stay.
  def restart
    profile.update!(card_builder_complete: false, card_builder_step: 1)
    render json: { ok: true }
  end

  # ────────────────────────────────────────────────────────────────────────────
  private

  def profile
    @profile ||= current_user.civic_profile
  end

  def require_provider_mode
    unless current_user
      return redirect_to new_session_path, alert: "Please sign in."
    end
    unless profile&.provider_mode?
      return redirect_to dashboard_path, alert: "Provider mode required."
    end
  end

  def slugify(str)
    str.to_s.downcase
       .gsub(/[^a-z0-9\s-]/, "")
       .strip
       .gsub(/\s+/, "-")
       .gsub(/-+/, "-")
  end

  def compute_locode(city, state)
    key = [city.to_s.downcase.strip, state.to_s.downcase.strip]
    CITY_LOCODE[key]
  end

  def serialize_item(item)
    {
      id:          item.id,
      title:       item.title,
      source_url:  item.source_url,
      description: item.description,
      item_type:   item.item_type,
      visibility:  item.visibility,
      created_at:  item.created_at
    }
  end
end
