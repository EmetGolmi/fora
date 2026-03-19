class OpenStatesService
  include HTTParty
  base_uri "https://v3.openstates.org"

  def initialize
    @api_key = ENV["OPENSTATES_API_KEY"]
  end

  def pennsylvania_bills
    response = self.class.get("/bills", query: {
      jurisdiction: "Pennsylvania",
      per_page: 20,
      include: %w[sponsorships abstracts votes]
    }, headers: headers)

    return [] unless response.success?

    results = response.parsed_response["results"] || []
    results.map { |bill| normalize(bill) }
  end

  private

  def headers
    { "X-API-KEY" => @api_key }
  end

  def normalize(bill)
    {
      source: "openstates",
      external_id: bill["id"],
      title: bill["title"],
      identifier: bill["identifier"],
      status: extract_status(bill),
      status_date: extract_status_date(bill),
      summary: extract_summary(bill),
      sponsors: extract_sponsors(bill),
      subjects: bill["subject"] || [],
      votes: extract_votes(bill)
    }
  end

  def extract_status(bill)
    latest_action = bill.dig("latest_action", "description")
    latest_action || "Unknown"
  end

  def extract_status_date(bill)
    bill.dig("latest_action", "date")
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
