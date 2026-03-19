class CongressBillsService
  include HTTParty
  base_uri "https://api.congress.gov/v3"

  def self.sync_federal_bills
    new.sync_federal_bills
  end

  def sync_federal_bills
    bills = fetch_bills
    synced = 0
    failed = 0

    bills.each do |bill|
      CivicBill.upsert(bill, unique_by: [:source, :external_id])
      synced += 1
    rescue => e
      Rails.logger.error("CongressBillsService: failed to sync bill #{bill[:external_id]}: #{e.message}")
      failed += 1
    end

    { synced: synced, failed: failed }
  end

  EXCLUDED_TYPES = %w[HCONRES SCONRES HRES SRES].freeze

  def fetch_bills
    response = self.class.get("/bill", query: {
      api_key: api_key,
      limit: 20,
      offset: 0,
      sort: "updateDate+desc",
      fromDateTime: "2025-01-01T00:00:00Z"
    })

    return [] unless response.success?

    bills = response.parsed_response.dig("bills") || []
    bills.reject { |b| EXCLUDED_TYPES.include?(b["type"].to_s.upcase) }
         .map { |bill| normalize(bill) }
  end

  private

  def api_key
    ENV["CONGRESS_API_KEY"]
  end

  def normalize(bill)
    bill_type = bill["type"].to_s.upcase
    number = bill["number"].to_s

    {
      source: "congress",
      external_id: "#{bill_type}-#{number}",
      identifier: format_identifier(bill_type, number),
      title: bill["title"],
      status: bill.dig("latestAction", "text").presence || "In Congress",
      status_date: bill.dig("latestAction", "actionDate"),
      summary: nil,
      sponsors: [],
      subjects: [],
      votes: [],
      jurisdiction: "federal"
    }
  end

  def format_identifier(bill_type, number)
    case bill_type
    when "HR"
      "H.R. #{number}"
    when "S"
      "S. #{number}"
    when "HRES"
      "H.Res. #{number}"
    when "SRES"
      "S.Res. #{number}"
    when "HJRES"
      "H.J.Res. #{number}"
    when "SJRES"
      "S.J.Res. #{number}"
    when "HCONRES"
      "H.Con.Res. #{number}"
    when "SCONRES"
      "S.Con.Res. #{number}"
    else
      "#{bill_type} #{number}"
    end
  end
end
