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
    action_text = bill["latest_action_description"].to_s
    {
      source:      "openstates",
      external_id: bill["id"],
      title:       bill["title"],
      identifier:  bill["identifier"],
      status:      action_text.presence || "Unknown",
      bill_stage:  extract_bill_stage(action_text),
      status_date: bill["latest_action_date"],
      summary:     extract_summary(bill),
      sponsors:    extract_sponsors(bill),
      subjects:    bill["subject"] || [],
      votes:       extract_votes(bill)
    }
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
