class IjdbEntry < ApplicationRecord
  CATEGORIES = %w[
    transportation
    screening_equipment
    law_enforcement
    private_sector
    biological
    venues_infrastructure
    intelligence
    current_ongoing
    opportunity_cost
    social_psychological
  ].freeze

  CATEGORY_LABELS = {
    "transportation"        => "Transportation",
    "screening_equipment"   => "Screening & Detection",
    "law_enforcement"       => "Law Enforcement",
    "private_sector"        => "Private Sector",
    "biological"            => "Biological Defense",
    "venues_infrastructure" => "Venues & Infrastructure",
    "intelligence"          => "Intelligence & Surveillance",
    "current_ongoing"       => "Current & Ongoing",
    "opportunity_cost"      => "Opportunity Cost",
    "social_psychological"  => "Social & Psychological",
  }.freeze

  CONFIDENCES = %w[documented estimated partial classified gap].freeze

  CONFIDENCE_LABELS = {
    "documented"  => "Documented",
    "estimated"   => "Estimated",
    "partial"     => "Partial",
    "classified"  => "Classified",
    "gap"         => "Gap — uncounted",
  }.freeze

  SCOPES = %w[local federal_share private classified].freeze

  AMOUNT_UNITS = %w[usd lives incidents].freeze

  # contributor_id is stored but no FK — User model not yet in schema
  # belongs_to :contributor, class_name: "User", optional: true  # TODO: add when User model exists

  validates :title,      presence: true
  validates :city,       presence: true
  validates :category,   presence: true, inclusion: { in: CATEGORIES }
  validates :confidence, inclusion: { in: CONFIDENCES }, allow_nil: true
  validates :scope,      inclusion: { in: SCOPES },      allow_nil: true
  validates :amount_unit, inclusion: { in: AMOUNT_UNITS }, allow_nil: true

  scope :for_city,        ->(city, country = "usa") { where(city: city.to_s.downcase, country: country) }
  scope :by_category,     -> { order(Arel.sql("display_order NULLS LAST"), :category, :created_at) }
  scope :foia_candidates, -> { where(foia_candidate: true) }
  scope :quantified,      -> { where.not(amount_low_cents: nil).or(where.not(amount_high_cents: nil)) }
  scope :unclassified,    -> { where.not(confidence: %w[classified gap]) }

  # ── Dollar helpers (cents → dollars) ────────────────────────────────────────

  def amount_low
    amount_low_cents ? amount_low_cents / 100.0 : nil
  end

  def amount_high
    amount_high_cents ? amount_high_cents / 100.0 : nil
  end

  # Returns a human-readable range string e.g. "$1.5B–$2.8B"
  # Returns nil if no amounts; "Classified" / "Gap — uncounted" for those confidences
  def formatted_range
    return "Classified"        if confidence == "classified"
    return "Gap — uncounted"   if confidence == "gap"
    return nil                 unless amount_low_cents || amount_high_cents

    low  = amount_low
    high = amount_high

    fmt = ->(n) {
      return "—" unless n
      if n >= 1_000_000_000
        v = n / 1_000_000_000.0
        "$#{v == v.floor ? v.to_i : v.round(1)}B"
      elsif n >= 1_000_000
        "$#{(n / 1_000_000.0).round.to_i}M"
      elsif n >= 1_000
        "$#{(n / 1_000.0).round.to_i}K"
      else
        "$#{n.to_i}"
      end
    }

    if low && high && low != high
      "#{fmt.call(low)}–#{fmt.call(high)}"
    elsif low
      "≥ #{fmt.call(low)}"
    else
      "≤ #{fmt.call(high)}"
    end
  end

  def category_label
    CATEGORY_LABELS[category] || category.to_s.humanize
  end

  def confidence_label
    CONFIDENCE_LABELS[confidence] || confidence.to_s.humanize
  end
end
