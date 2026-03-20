class CongressBillsService
  include HTTParty
  base_uri "https://api.congress.gov/v3"

  def self.sync_federal_bills
    new.sync_federal_bills
  end

  def sync_federal_bills
    bills = fetch_senator_bills
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

  private

  def fetch_senator_bills
    senators = pa_senators
    if senators.empty?
      Rails.logger.warn("CongressBillsService: no PA senators found")
      return []
    end

    senators.flat_map do |senator|
      bioguide = senator["bioguideId"]
      fetch_sponsored_bills(bioguide)
    end
  end

  def pa_senators
    response = self.class.get("/member/PA", query: { api_key: api_key, limit: 50 })
    unless response.success?
      Rails.logger.error("CongressBillsService: /member/PA returned #{response.code}")
      return []
    end

    members = response.parsed_response.dig("members") || []
    members.select { |m| senator?(m) }
  end

  def senator?(member)
    terms = member["terms"]&.dig("item") || []
    terms = [terms] unless terms.is_a?(Array)
    terms.any? { |t| t["chamber"].to_s.downcase == "senate" }
  end

  def fetch_sponsored_bills(bioguide)
    response = self.class.get("/member/#{bioguide}/sponsored-legislation", query: {
      api_key: api_key,
      limit: 3,
      sort: "introducedDate+desc"
    })

    unless response.success?
      Rails.logger.error("CongressBillsService: sponsored-legislation for #{bioguide} returned #{response.code}")
      return []
    end

    bills = response.parsed_response.dig("sponsoredLegislation") || []
    bills.filter_map { |bill| normalize(bill) }
  end

  def normalize(bill)
    bill_type = bill["type"].to_s.upcase
    number    = bill["number"].to_s
    return nil if bill_type.empty? || number.empty?

    {
      source:      "congress",
      external_id: "#{bill_type}-#{number}",
      identifier:  format_identifier(bill_type, number),
      title:       bill["title"],
      status:      bill.dig("latestAction", "text").presence || "In Congress",
      status_date: bill.dig("latestAction", "actionDate"),
      summary:     nil,
      sponsors:    [],
      subjects:    [],
      votes:       [],
      jurisdiction: "federal"
    }
  end

  def format_identifier(bill_type, number)
    case bill_type
    when "HR"      then "H.R. #{number}"
    when "S"       then "S. #{number}"
    when "HRES"    then "H.Res. #{number}"
    when "SRES"    then "S.Res. #{number}"
    when "HJRES"   then "H.J.Res. #{number}"
    when "SJRES"   then "S.J.Res. #{number}"
    when "HCONRES" then "H.Con.Res. #{number}"
    when "SCONRES" then "S.Con.Res. #{number}"
    else                "#{bill_type} #{number}"
    end
  end

  def api_key
    ENV["CONGRESS_API_KEY"]
  end
end
