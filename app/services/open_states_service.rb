class OpenStatesService
  include HTTParty
  base_uri "https://v3.openstates.org"

  def initialize
    @api_key = ENV["OPENSTATES_API_KEY"]
  end

  def pennsylvania_bills
    base_query = {
      jurisdiction: "Pennsylvania",
      per_page:     100,
      sort:         "latest_action_date",
      include:      %w[sponsorships abstracts votes]
    }

    (1..3).flat_map do |page|
      response = self.class.get("/bills", query: base_query.merge(page: page), headers: headers)
      break unless response.success?

      results = response.parsed_response["results"] || []
      break if results.empty?

      results.map { |bill| normalize(bill) }
    end
  end

  # Batch-refresh a collection of bills using the list endpoint (100/request).
  # Returns { ok: N, rate_limited: N, not_found: N }.
  def refresh_bills(bills)
    counts = { ok: 0, rate_limited: 0, not_found: 0 }
    identifiers_to_bill = bills.index_by(&:identifier)

    identifiers_to_bill.each_slice(50) do |slice|
      identifiers = slice.map(&:first)
      response = self.class.get("/bills", query: {
        jurisdiction: "Pennsylvania",
        per_page:     identifiers.size,
        include:      "sponsorships,abstracts,votes,sources"
      }.merge(
        # OpenStates doesn't support multi-identifier in one call, so we page
      ), headers: headers)

      if response.code == 429
        counts[:rate_limited] += slice.size
        raise RateLimitError, "OpenStates 429 — daily quota exceeded"
      end
      next unless response.success?

      (response.parsed_response["results"] || []).each do |data|
        bill = identifiers_to_bill[data["identifier"]]
        next counts[:not_found] += 1 unless bill

        attrs = normalize(data)
        if bill.raw_data.is_a?(Hash) && bill.raw_data["curated_effects"].present?
          attrs[:raw_data] = attrs[:raw_data].merge("curated_effects" => bill.raw_data["curated_effects"])
        end
        bill.update!(attrs.except(:source, :external_id))
        counts[:ok] += 1
      end
    end
    counts
  end

  # Single-bill refresh by OpenStates ID. Raises RateLimitError on 429.
  def refresh_bill(bill)
    response = self.class.get(
      "/bills/#{bill.external_id}",
      query:   { include: %w[sponsorships abstracts votes sources] },
      headers: headers
    )
    raise RateLimitError, "OpenStates 429 — daily quota exceeded" if response.code == 429
    return false unless response.success?

    data  = response.parsed_response
    attrs = normalize(data)
    if bill.raw_data.is_a?(Hash) && bill.raw_data["curated_effects"].present?
      attrs[:raw_data] = attrs[:raw_data].merge("curated_effects" => bill.raw_data["curated_effects"])
    end
    bill.update!(attrs.except(:source, :external_id))
    true
  end

  RateLimitError = Class.new(StandardError)

  private

  def headers
    { "X-API-KEY" => @api_key }
  end

  def self.backfill_status
    service = new
    api_key  = ENV["OPENSTATES_API_KEY"]
    headers  = { "X-API-KEY" => api_key }

    CivicBill.where(jurisdiction: ["pennsylvania", "federal", "philadelphia"]).find_each do |bill|
      response = HTTParty.get(
        "https://v3.openstates.org/bills",
        query:   { jurisdiction: "Pennsylvania", identifier: bill.identifier },
        headers: headers
      )
      next unless response.success?

      result      = response.parsed_response["results"]&.first
      action_text = result&.dig("latest_action_description").to_s
      next if action_text.blank?

      bill.update_columns(
        status:     action_text,
        bill_stage: service.send(:extract_bill_stage, action_text)
      )
    end
  end

  def normalize(bill)
    action_text  = bill["latest_action_description"].to_s
    session_str  = bill["session"] || bill["legislative_session"] || ""
    session_year = session_str.match(/(\d{4})/)[1] rescue "2025"
    {
      source:             "openstates",
      external_id:        bill["id"],
      title:              bill["title"],
      identifier:         bill["identifier"],
      status:             action_text.presence || "Unknown",
      bill_stage:         extract_bill_stage(action_text),
      status_date:        bill["latest_action_date"],
      summary:            extract_summary(bill),
      sponsors:           extract_sponsors(bill),
      subjects:           bill["subject"] || [],
      votes:              extract_votes(bill),
      session_identifier: session_str.presence,
      full_text_url:      build_pa_url(bill["identifier"], session_year),
      raw_data:           bill
    }
  end

  def build_pa_url(identifier, session_year)
    return nil unless identifier =~ /\A([HS])([BR])\s+(\d+)\z/i
    body   = Regexp.last_match(1).upcase
    type   = Regexp.last_match(2).upcase
    number = Regexp.last_match(3)
    "https://www.legis.state.pa.us/cfdocs/billinfo/billinfo.cfm" \
      "?syear=#{session_year}&sind=0&body=#{body}&type=#{type}&bn=#{number}"
  end

  def extract_bill_stage(text)
    t = text.downcase
    if t.match?(/laid on the table|failed|defeated|withdrawn/)
      "failed"
    elsif t.match?(/act no\.|became law|signed|enacted|adopted|final passage/)
      "became_law"
    elsif t.match?(/in council|passed|approved|third reading/)
      "passed_chamber"
    elsif t.match?(/ordered to be reported|in committee|committee consideration/)
      "committee"
    elsif t.match?(/referred|introduced|read twice/)
      "introduced"
    else
      "introduced"
    end
  end

  def extract_summary(bill)
    abstracts = bill["abstracts"] || []
    abstracts.dig(0, "abstract")
  end

  def extract_sponsors(bill)
    sponsorships = bill["sponsorships"] || []
    sponsorships.map do |s|
      { name: s["name"], role: s["classification"], primary: s["primary"] }
    end
  end

  def extract_votes(bill)
    votes = bill["votes"] || []
    votes.map do |v|
      {
        motion: v["motion_text"],
        result: v["result"],
        date: v["start_date"],
        counts: (v["counts"] || []).map { |c| { option: c["option"], value: c["value"] } }
      }
    end
  end
end
