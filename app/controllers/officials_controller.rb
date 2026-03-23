class OfficialsController < ApplicationController
  include HTTParty
  base_uri "https://api.congress.gov/v3"

  WIKI_FILENAMES = {
    "F000479" => "John_Fetterman_official_portrait.jpg",
    "M001243" => "McCormick_Portrait_(HR).jpg",
    "E000296" => "Dwight_Evans_official_photo_(cropped).jpg"
  }.freeze

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

    bill_type_labels = {
      "HR" => "H.R.", "S" => "S.", "HJRES" => "H.J.Res.", "SJRES" => "S.J.Res.",
      "HRES" => "H.Res.", "SRES" => "S.Res.", "HCONRES" => "H.Con.Res.", "SCONRES" => "S.Con.Res."
    }
    member_name = @member["name"].to_s
    fec_office  = @member.dig("terms")&.last&.fetch("chamber", nil) == "Senate" ? "S" : "H"

    mutex   = Mutex.new
    threads = []

    # Wikipedia photo
    threads << Thread.new do
      wiki_filename = WIKI_FILENAMES[bioguide_id]
      next unless wiki_filename.present?
      begin
        resp = HTTParty.get(
          "https://en.wikipedia.org/w/api.php",
          query:   { action: "query", titles: "File:#{wiki_filename}", prop: "imageinfo",
                     iiprop: "url", iiurlwidth: 960, format: "json" },
          headers: { "User-Agent" => "FORA/1.0 (fora.center)" }
        )
        photo = resp.success? ? resp.parsed_response.dig("query", "pages")&.values&.first&.dig("imageinfo", 0, "thumburl") : nil
        mutex.synchronize { @wiki_photo = photo }
      rescue
        mutex.synchronize { @wiki_photo = nil }
      end
    end

    # Sponsored legislation + upsert
    threads << Thread.new do
      ActiveRecord::Base.connection_pool.with_connection do
        resp  = self.class.get("/member/#{bioguide_id}/sponsored-legislation",
                               query: { api_key: api_key, limit: 5, sort: "introducedDate+desc" })
        bills = resp.success? ? (resp.parsed_response["sponsoredLegislation"] || []) : []

        bills.each do |bill|
          type = bill["type"].to_s.upcase
          prefix = bill_type_labels[type] || type
          bill["_identifier"]  = "#{prefix} #{bill['number']}"
          bill["_external_id"] = "#{type}-#{bill['number']}"
        end

        identifiers = bills.map { |b| b["_identifier"] }
        bill_id_map = CivicBill.where(identifier: identifiers).pluck(:identifier, :id).to_h

        unmatched = bills.reject { |b| bill_id_map.key?(b["_identifier"]) }
        if unmatched.any?
          now  = Time.current
          rows = unmatched.map do |bill|
            raw_status = bill.dig("latestAction", "text").to_s.presence
            { source: "congress", external_id: bill["_external_id"], identifier: bill["_identifier"],
              title: bill["title"].to_s, status: raw_status, bill_stage: CivicBill.classify_stage(raw_status),
              status_date: bill.dig("latestAction", "actionDate").then { |d| Date.parse(d) rescue nil },
              jurisdiction: "federal", created_at: now, updated_at: now }
          end
          CivicBill.upsert_all(rows, unique_by: %i[source external_id], update_only: %i[title status bill_stage status_date])
          bill_id_map = CivicBill.where(identifier: identifiers).pluck(:identifier, :id).to_h
        end

        bills_active   = bills.select { |b| CivicBill::ACTIVE_STAGES.include?(CivicBill.classify_stage(b.dig("latestAction", "text").to_s)) }
        bills_resolved = bills.reject { |b| CivicBill::ACTIVE_STAGES.include?(CivicBill.classify_stage(b.dig("latestAction", "text").to_s)) }

        mutex.synchronize do
          @bills          = bills
          @bill_id_map    = bill_id_map
          @bills_active   = bills_active
          @bills_resolved = bills_resolved
        end
      end
    end

    # Committee memberships
    threads << Thread.new do
      resp = self.class.get("/member/#{bioguide_id}/committees", query: { api_key: api_key })
      committees = if resp.success?
        raw     = resp.parsed_response["committeeHistory"] || resp.parsed_response["committees"] || []
        current = raw.select { |c| c["endDate"].nil? }
        (current.any? ? current : raw).first(4).map do |c|
          { name: c.dig("committee", "name") || c["name"] || c["committeeName"] || "Committee",
            role: c["memberType"] || c["role"] || "" }
        end
      else
        []
      end
      mutex.synchronize { @committees = committees }
    end

    # FEC campaign finance (two-step)
    threads << Thread.new do
      begin
        step1 = HTTParty.get("https://api.open.fec.gov/v1/candidates/search/",
                             query: { api_key: ENV["FEC_API_KEY"], q: member_name,
                                      office: fec_office, state: "PA", per_page: 1 })
        candidate_id = step1.success? ? step1.parsed_response.dig("results", 0, "candidate_id") : nil
        Rails.logger.debug "[FORA] FEC candidate_id for #{member_name} (office=#{fec_office}): #{candidate_id.inspect}"

        if candidate_id.present?
          step2  = HTTParty.get("https://api.open.fec.gov/v1/candidate/#{candidate_id}/totals/",
                                query: { api_key: ENV["FEC_API_KEY"], per_page: 1, sort: "-cycle" })
          result = step2.success? ? step2.parsed_response.dig("results", 0) : nil
          Rails.logger.debug "[FORA] FEC receipts for #{member_name}: #{result&.dig('receipts').inspect} (cycle #{result&.dig('cycle').inspect})"
          mutex.synchronize do
            @fec_total_raised = result&.dig("receipts")
            @fec_cycle        = result&.dig("cycle")
          end
        end
      rescue
        mutex.synchronize { @fec_total_raised = nil; @fec_cycle = nil }
      end
    end

    # GovTrack voting stats + committees (scraped)
    threads << Thread.new do
      govtrack = GovtrackService.fetch(bioguide_id)
      mutex.synchronize do
        @party_vote_pct   = govtrack[:party_vote_pct]
        @missed_votes_pct = govtrack[:missed_votes_pct]
        # Use GovTrack committees as fallback if Congress.gov returned none
        if @committees.blank? && govtrack[:committees].present?
          @committees = govtrack[:committees].map { |name| { name: name, role: "" } }
        end
      end
    end

    # NewsAPI
    threads << Thread.new do
      begin
        news_resp = HTTParty.get(
          "https://newsapi.org/v2/everything",
          query: { apiKey: ENV["NEWSAPI_KEY"], q: "\"#{member_name.split.last}\"",
                   language: "en", sortBy: "publishedAt", pageSize: 5 }
        )
        mutex.synchronize do
          @news_articles = news_resp.success? ? (news_resp.parsed_response["articles"] || []) : []
        end
      rescue
        mutex.synchronize { @news_articles = [] }
      end
    end

    threads.each(&:join)

    Rails.logger.debug "[FORA] @committees for #{bioguide_id}: #{@committees.inspect}"
    Rails.logger.debug "[FORA] FEC_API_KEY present: #{ENV['FEC_API_KEY'].present?}"
  end

  def state_show
    openstates_id = params[:openstates_id]
    api_key       = ENV["OPENSTATES_API_KEY"]

    person_response = HTTParty.get(
      "https://v3.openstates.org/people/#{openstates_id}",
      query: { apikey: api_key }
    )

    unless person_response.success?
      render plain: "Official not found", status: :not_found
      return
    end

    person       = person_response.parsed_response
    current_role = person["current_role"] || {}
    is_senator   = current_role["org_classification"] == "upper"
    district     = current_role["district"].to_s.presence

    @member = {
      "name"               => person["name"],
      "image"              => person["image"],
      "party"              => person["party"],
      "title"              => current_role["title"],
      "district"           => district,
      "org_classification" => current_role["org_classification"],
      "division_id"        => current_role["division_id"],
      "openstates_id"      => openstates_id
    }

    @office_title = if is_senator
      district ? "State Senator · District #{district}" : "State Senator · Pennsylvania"
    else
      district ? "State Representative · District #{district}" : "State Representative · Pennsylvania"
    end

    @social = extract_state_social(person["links"] || [])

    bills_response = HTTParty.get(
      "https://v3.openstates.org/bills",
      query: { sponsor_id: openstates_id, apikey: api_key, sort: "updated_desc", per_page: 5 }
    )

    @bills = bills_response.success? ? (bills_response.parsed_response["results"] || []) : []

    identifiers  = @bills.map { |b| b["identifier"] }
    @bill_id_map = CivicBill.where(identifier: identifiers, jurisdiction: "pennsylvania").pluck(:identifier, :id).to_h

    @bills_active   = @bills.select { |b| CivicBill::ACTIVE_STAGES.include?(CivicBill.classify_stage(b["latest_action_description"].to_s)) }
    @bills_resolved = @bills.reject { |b| CivicBill::ACTIVE_STAGES.include?(CivicBill.classify_stage(b["latest_action_description"].to_s)) }
  end

  private

  def extract_state_social(links)
    social = {}
    links.each do |link|
      url = link["url"].to_s.strip
      next if url.blank?
      case url
      when /(?:twitter|x)\.com\/(?:intent\/user\?screen_name=)?([A-Za-z0-9_]+)/
        social[:twitter]   ||= $1
      when /facebook\.com\/([^\/\?]+)/
        social[:facebook]  ||= $1
      when /instagram\.com\/([^\/\?]+)/
        social[:instagram] ||= $1
      when /youtube\.com/
        social[:youtube]   ||= url
      when /tiktok\.com\/@?([^\/\?]+)/
        social[:tiktok]    ||= $1
      else
        social[:website]   ||= url
      end
    end
    social
  end
end
