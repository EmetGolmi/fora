class IjdbEntriesController < ApplicationController
  # Population share of US total (city / ~331M) — used to estimate federal spending share
  POPULATION_SHARES = {
    "philadelphia" => 1_576_000.0 / 331_000_000,   # ~0.476%
    "new_york"     => 8_336_000.0 / 331_000_000,
    "chicago"      => 2_696_000.0 / 331_000_000,
    "los_angeles"  => 3_898_000.0 / 331_000_000,
  }.freeze

  # Total US anti-terrorism / homeland security spending since 9/11 (est. $8T+)
  FEDERAL_ANTITERROR_TOTAL_CENTS = 8_000_000_000_000 * 100

  before_action :set_location
  skip_before_action :set_location, only: :national

  NATIONAL_STATS = [
    { value: "~$8T",  label: "Total estimated CT spending",    sub: "2002–2022 · Brown Univ. Costs of War",  color: "gilt" },
    { value: "$1.1T", label: "Homeland security spending",     sub: "DHS-related programs, 2002–2022",       color: "gilt" },
    { value: "$2.3T", label: "Overseas contingency ops (DOD)", sub: "Afghanistan, Iraq, Syria, OCO",         color: "gilt" },
    { value: "$260B", label: "CT spending peak year",          sub: "2008 · 16× the pre-9/11 baseline",      color: "gilt" },
    { value: "15%",   label: "Of discretionary budget",        sub: "2002–17 avg · Stimson Center",          color: "gilt" },
    { value: "3,800+", label: "Jihadi-caused U.S. deaths",      sub: "1627 Little James through 2025 · slavery counted as death · FORA framework", color: "red", modal_id: "deaths-modal" },
  ].freeze

  def national
    @country = "usa"
    all = IjdbEntry.national.by_category
    @agency_entries = all.reject { |e| e.entity_name == "USPS" }
    @mail_entries   = all.select { |e| e.entity_name == "USPS" }
    @stats = NATIONAL_STATS
    @max_agency_cents = @agency_entries.map { |e| e.amount_low_cents.to_i }.max.to_f
  end

  def index
    @entries = IjdbEntry.for_city(@city, @country).by_category
    @entries_by_category = @entries.group_by(&:category)

    quantified = @entries.select { |e| e.amount_low_cents || e.amount_high_cents }
    @city_total_low  = quantified.sum { |e| e.amount_low_cents.to_i  } / 100.0
    @city_total_high = quantified.sum { |e| e.amount_high_cents.to_i } / 100.0

    share = POPULATION_SHARES[@city] || 0
    @federal_share = (share * FEDERAL_ANTITERROR_TOTAL_CENTS) / 100.0

    @comments = IjdbComment.for_city(@city, @country).city_level.recent.limit(20)
    @new_comment = IjdbComment.new(city: @city, country: @country)
  end

  def show
    @entry = IjdbEntry.for_city(@city, @country).find(params[:id])
    @comments = @entry.ijdb_comments.recent
    @new_comment = IjdbComment.new(city: @city, country: @country, ijdb_entry: @entry)
  rescue ActiveRecord::RecordNotFound
    redirect_to city_ijdb_path(city: @city), alert: "Entry not found."
  end

  private

  def set_location
    @city    = params[:city].to_s.downcase
    @country = "usa"   # hardcoded for current URL schema (/usa/:city/...)
  end
end
