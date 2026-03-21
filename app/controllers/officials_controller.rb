class OfficialsController < ApplicationController
  include HTTParty
  base_uri "https://api.congress.gov/v3"

  def show
    bioguide_id = params[:bioguide_id]
    api_key = ENV["CONGRESS_API_KEY"]

    member_response = self.class.get("/member/#{bioguide_id}", query: { api_key: api_key })

    unless member_response.success?
      render plain: "Official not found", status: :not_found
      return
    end

    @member = member_response.parsed_response["member"]
    @social = CongressSocialService.for_bioguide(bioguide_id)
    @social[:website] ||= @member["officialWebsiteUrl"]

    bills_response = self.class.get("/member/#{bioguide_id}/sponsored-legislation", query: {
      api_key: api_key,
      limit: 5,
      sort: "introducedDate+desc"
    })

    @bills = if bills_response.success?
      bills_response.parsed_response["sponsoredLegislation"] || []
    else
      []
    end

    bill_type_labels = {
      "HR" => "H.R.", "S" => "S.", "HJRES" => "H.J.Res.", "SJRES" => "S.J.Res.",
      "HRES" => "H.Res.", "SRES" => "S.Res.", "HCONRES" => "H.Con.Res.", "SCONRES" => "S.Con.Res."
    }

    # Annotate each bill with its formatted identifier and external_id
    @bills.each do |bill|
      type   = bill["type"].to_s.upcase
      prefix = bill_type_labels[type] || type
      bill["_identifier"]  = "#{prefix} #{bill['number']}"
      bill["_external_id"] = "#{type}-#{bill['number']}"
    end

    identifiers  = @bills.map { |b| b["_identifier"] }
    @bill_id_map = CivicBill.where(identifier: identifiers).pluck(:identifier, :id).to_h

    # Upsert any bills not yet in the database
    unmatched = @bills.reject { |b| @bill_id_map.key?(b["_identifier"]) }
    if unmatched.any?
      now = Time.current
      rows = unmatched.map do |bill|
        {
          source:       "congress",
          external_id:  bill["_external_id"],
          identifier:   bill["_identifier"],
          title:        bill["title"].to_s,
          status:       bill.dig("latestAction", "text").to_s.presence,
          status_date:  bill.dig("latestAction", "actionDate").then { |d| Date.parse(d) rescue nil },
          jurisdiction: "federal",
          created_at:   now,
          updated_at:   now
        }
      end
      CivicBill.upsert_all(rows, unique_by: %i[source external_id], update_only: %i[title status status_date])
      @bill_id_map = CivicBill.where(identifier: identifiers).pluck(:identifier, :id).to_h
    end
  end
end
