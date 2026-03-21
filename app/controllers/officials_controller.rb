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
    identifiers = @bills.map do |bill|
      prefix = bill_type_labels[bill["type"].to_s.upcase] || bill["type"].to_s.upcase
      "#{prefix} #{bill['number']}"
    end
    @bill_id_map = CivicBill.where(identifier: identifiers).pluck(:identifier, :id).to_h
  end
end
