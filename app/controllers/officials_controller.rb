class OfficialsController < ApplicationController
  include HTTParty
  base_uri "https://api.congress.gov/v3"

  WIKI_FILENAMES = {
    "F000479" => "John_Fetterman_official_portrait.jpg",
    "M001243" => "McCormick_Portrait_(HR).jpg",
    "E000296" => "Dwight_Evans_official_photo_(cropped).jpg"
  }.freeze

  FEC_IDS = {
    "F000479" => "S6PA00274",
    "M001243" => "S2PA00661",
    "E000296" => "H6PA02171"
  }.freeze

  STATE_OFFICIALS = {
    "ocd-person/6f172bc8-50b0-4dd3-aed6-b5fd48b70eeb" => {
      "name"  => "Nikil Saval",
      "party" => "Democratic",
      "image" => nil,
      "id"    => "ocd-person/6f172bc8-50b0-4dd3-aed6-b5fd48b70eeb",
      "links" => [{ "url" => "https://www.senatornikils.com" }],
      "current_role" => {
        "org_classification" => "upper",
        "district"           => "1",
        "title"              => "Senator",
        "division_id"        => ""
      }
    },
    "ocd-person/1f2c3093-8ce7-41f7-8df0-6cd14ddd354b" => {
      "name"  => "Ben Waxman",
      "party" => "Democratic",
      "image" => nil,
      "id"    => "ocd-person/1f2c3093-8ce7-41f7-8df0-6cd14ddd354b",
      "links" => [{ "url" => "https://www.pahouse.com/waxman" }],
      "current_role" => {
        "org_classification" => "lower",
        "district"           => "182",
        "title"              => "Representative",
        "division_id"        => ""
      }
    }
  }.freeze

  HARDCODED_MEMBERS = {
    "F000479" => {
      "bioguideId"       => "F000479",
      "directOrderName"  => "John Fetterman",
      "name"             => "Fetterman, John",
      "partyName"        => "Democratic",
      "officialWebsiteUrl" => "https://www.fetterman.senate.gov",
      "terms"            => [{ "chamber" => "Senate", "startYear" => 2023 }],
      "depiction"        => { "imageUrl" => "https://bioguide.congress.gov/bioguide/photo/F/F000479.jpg" },
      "addressInformation" => { "officeAddress" => "152 Russell Senate Office Building\nWashington, DC 20510", "phoneNumber" => "(202) 224-4254" }
    },
    "M001243" => {
      "bioguideId"       => "M001243",
      "directOrderName"  => "David McCormick",
      "name"             => "McCormick, David",
      "partyName"        => "Republican",
      "officialWebsiteUrl" => "https://www.mccormick.senate.gov",
      "terms"            => [{ "chamber" => "Senate", "startYear" => 2025 }],
      "depiction"        => { "imageUrl" => "https://bioguide.congress.gov/bioguide/photo/M/M001243.jpg" },
      "addressInformation" => { "officeAddress" => "", "phoneNumber" => "(202) 224-6324" }
    },
    "E000296" => {
      "bioguideId"       => "E000296",
      "directOrderName"  => "Dwight Evans",
      "name"             => "Evans, Dwight",
      "partyName"        => "Democratic",
      "officialWebsiteUrl" => "https://evans.house.gov",
      "terms"            => [{ "chamber" => "House", "district" => "3", "startYear" => 2016 }],
      "depiction"        => { "imageUrl" => "https://bioguide.congress.gov/bioguide/photo/E/E000296.jpg" },
      "addressInformation" => { "officeAddress" => "2368 Rayburn House Office Building\nWashington, DC 20515", "phoneNumber" => "(202) 225-4001" }
    },
    "B001296" => {
      "bioguideId"       => "B001296",
      "directOrderName"  => "Brendan Boyle",
      "name"             => "Boyle, Brendan",
      "partyName"        => "Democratic",
      "officialWebsiteUrl" => "https://boyle.house.gov",
      "terms"            => [{ "chamber" => "House", "district" => "2", "startYear" => 2015 }],
      "depiction"        => { "imageUrl" => "https://bioguide.congress.gov/bioguide/photo/B/B001296.jpg" },
      "addressInformation" => { "officeAddress" => "1133 Longworth House Office Building\nWashington, DC 20515", "phoneNumber" => "(202) 225-6111" }
    }
  }.freeze

  COMMITTEE_ISSUE_CODES = {
    "F000479" => %w[BNK AGR ENV BUD],
    "M001243" => %w[BNK DEF BUD],
    "E000296" => %w[HCR TAX SBA]
  }.freeze

  HARDCODED_VOTING_STATS = {
    "F000479" => { party_vote_pct: 68.0, missed_votes_pct: 13.9, votes_cast: "~1,205 of ~1,400", chamber_avg_attendance: 93.0, chamber_avg_party: 88.0 },
    "M001243" => { party_vote_pct: 95.0, missed_votes_pct:  2.8, votes_cast: "~1,361 of ~1,400", chamber_avg_attendance: 93.0, chamber_avg_party: 88.0 },
    "E000296" => { party_vote_pct: 96.0, missed_votes_pct: 14.8, votes_cast: "~1,150 of ~1,350", chamber_avg_attendance: 95.0, chamber_avg_party: 92.0 },
    "B001296" => { party_vote_pct: 97.0, missed_votes_pct:  5.2, votes_cast: "~1,280 of ~1,350", chamber_avg_attendance: 95.0, chamber_avg_party: 92.0 }
  }.freeze

  def show
    bioguide_id = params[:bioguide_id]
    api_key     = ENV["CONGRESS_API_KEY"]

    @member = HARDCODED_MEMBERS[bioguide_id]

    # Try to enrich with live Congress.gov data if available
    begin
      member_response = self.class.get("/member/#{bioguide_id}", query: { api_key: api_key })
      live = member_response.parsed_response["member"] if member_response.success?
      @member = live if live.present?
    rescue
      # API unavailable; fall back to hardcoded
    end

    if @member.nil?
      render plain: "Official not found", status: :not_found
      return
    end
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
        photo = resp.success? ? resp.parsed_response.dig("query","pages")&.values&.first&.dig("imageinfo",0,"thumburl") : nil
        mutex.synchronize { @wiki_photo = photo }
      rescue
        mutex.synchronize { @wiki_photo = nil }
      end
    end

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
            raw_status = bill.dig("latestAction","text").to_s.presence
            { source: "congress", external_id: bill["_external_id"], identifier: bill["_identifier"],
              title: bill["title"].to_s, status: raw_status, bill_stage: CivicBill.classify_stage(raw_status),
              status_date: bill.dig("latestAction","actionDate").then { |d| Date.parse(d) rescue nil },
              jurisdiction: "federal", created_at: now, updated_at: now }
          end
          CivicBill.upsert_all(rows, unique_by: %i[source external_id], update_only: %i[title status bill_stage status_date])
          bill_id_map = CivicBill.where(identifier: identifiers).pluck(:identifier, :id).to_h
        end

        mutex.synchronize do
          @bills          = bills
          @bill_id_map    = bill_id_map
          @bills_active   = bills.select { |b| CivicBill::ACTIVE_STAGES.include?(CivicBill.classify_stage(b.dig("latestAction","text").to_s)) }
          @bills_resolved = bills.reject { |b| CivicBill::ACTIVE_STAGES.include?(CivicBill.classify_stage(b.dig("latestAction","text").to_s)) }
        end
      end
    end

threads << Thread.new do
  resp = self.class.get("/member/#{bioguide_id}/committees", query: { api_key: api_key })
  committees = if resp.success?
    raw     = resp.parsed_response["committeeHistory"] || resp.parsed_response["committees"] || []
    current = raw.select { |c| c["endDate"].nil? }
    (current.any? ? current : raw).first(6).map do |c|
      { name: c.dig("committee","name") || c["name"] || c["committeeName"] || "Committee",
        role: c["memberType"] || c["role"] || "" }
    end
  else
    []
  end
  # Fall back to hardcoded GovTrack data if API returns nothing
  if committees.empty?
    govtrack = GovtrackService.fetch(bioguide_id)
    committees = (govtrack[:committees] || []).map do |c|
      { name: c[:name], role: c[:role] }
    end
  end
  mutex.synchronize { @committees = committees }
end

    threads << Thread.new do
      begin
        step1 = HTTParty.get("https://api.open.fec.gov/v1/candidates/search/",
                             query: { api_key: ENV["FEC_API_KEY"], q: member_name,
                                      office: fec_office, state: "PA", per_page: 1 })
        candidate_id = step1.success? ? step1.parsed_response.dig("results",0,"candidate_id") : nil
        if candidate_id.present?
          step2  = HTTParty.get("https://api.open.fec.gov/v1/candidate/#{candidate_id}/totals/",
                                query: { api_key: ENV["FEC_API_KEY"], per_page: 1, sort: "-cycle" })
          result = step2.success? ? step2.parsed_response.dig("results",0) : nil
          mutex.synchronize { @fec_total_raised = result&.dig("receipts"); @fec_cycle = result&.dig("cycle") }
        end
      rescue
        mutex.synchronize { @fec_total_raised = nil; @fec_cycle = nil }
      end
    end

    threads << Thread.new do
      stats = GovtrackService.fetch(bioguide_id)
      mutex.synchronize do
        @missed_votes_pct       = stats[:missed_votes_pct]
        @party_vote_pct         = stats[:party_vote_pct]
        @votes_cast             = stats[:votes_cast]
        @chamber_avg_attendance = stats[:chamber_avg_attendance]
        @chamber_avg_party      = stats[:chamber_avg_party]
      end
    end

    threads << Thread.new do
      begin
        news_resp = HTTParty.get("https://newsapi.org/v2/everything",
                                 query: { apiKey: ENV["NEWSAPI_KEY"], q: "\"#{member_name.split.last}\"",
                                          language: "en", sortBy: "publishedAt", pageSize: 5 })
        mutex.synchronize { @news_articles = news_resp.success? ? (news_resp.parsed_response["articles"] || []) : [] }
      rescue
        mutex.synchronize { @news_articles = [] }
      end
    end

    threads << Thread.new do
      begin
        fec_cand = FEC_IDS[bioguide_id]
        next unless fec_cand
        pacs = Rails.cache.fetch("fec_pacs/#{fec_cand}", expires_in: 6.hours) do
          cmte_resp = HTTParty.get("https://api.open.fec.gov/v1/candidate/#{fec_cand}/committees/",
                                   query: { api_key: ENV["FEC_API_KEY"], designation: "P" }, timeout: 8)
          cmte_id = cmte_resp.success? ? cmte_resp.parsed_response.dig("results", 0, "committee_id") : nil
          next [] unless cmte_id
          sched_resp = HTTParty.get("https://api.open.fec.gov/v1/schedules/schedule_a/",
                                    query: { api_key: ENV["FEC_API_KEY"], committee_id: cmte_id,
                                             contributor_type: "committee",
                                             sort: "-contribution_receipt_amount", per_page: 20 }, timeout: 10)
          rows = sched_resp.success? ? (sched_resp.parsed_response["results"] || []) : []
          rows.group_by { |r| r["contributor_name"] }
              .map { |name, recs| { name: name, total: recs.sum { |r| r["contribution_receipt_amount"].to_f } } }
              .sort_by { |p| -p[:total] }.first(5)
        end
        mutex.synchronize { @top_pacs = pacs }
      rescue
        mutex.synchronize { @top_pacs = [] }
      end
    end

    threads.each(&:join)

    fec_cand_id = FEC_IDS[bioguide_id]
    @finance = OfficialFinanceSummary.where(fec_candidate_id: fec_cand_id).order(cycle_year: :desc).first if fec_cand_id

    @social_handles = {
      "F000479" => { x: "SenJohnFetterman", instagram: "senjohnfetterman", youtube: nil,             website: "https://www.fetterman.senate.gov" },
      "M001243" => { x: "SenMcCormickPA",   instagram: "senmccormickpa",   youtube: "SenMcCormickPA", website: "https://www.mccormick.senate.gov" },
      "E000296" => { x: "RepDwightEvans",    instagram: "repdwightevans",   youtube: nil,             website: "https://evans.house.gov" },
      "B001296" => { x: "RepBrendanBoyle",   instagram: nil,                youtube: nil,             website: "https://boyle.house.gov" }
    }[bioguide_id] || {}
  end

  def state_show
    openstates_id = params[:openstates_id]

    person = STATE_OFFICIALS[openstates_id]

    if person.nil?
      begin
        person_response = HTTParty.get(
          "https://v3.openstates.org/people/#{openstates_id}",
          query: { apikey: ENV["OPENSTATES_API_KEY"] }, timeout: 8
        )
        person = person_response.success? ? person_response.parsed_response : nil
      rescue
        person = nil
      end
    end

    unless person
      render plain: "Official not found", status: :not_found
      return
    end

    current_role = person["current_role"] || {}
    is_senator   = current_role["org_classification"] == "upper"
    district     = current_role["district"].to_s.presence

    @member = {
      "name"               => person["name"],
      "image"              => person["image"],
      "party"              => person["party"],
      "id"                 => person["id"] || openstates_id,
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

    begin
      bills_response = HTTParty.get(
        "https://v3.openstates.org/bills",
        query: { sponsor_id: openstates_id, apikey: ENV["OPENSTATES_API_KEY"],
                 sort: "updated_desc", per_page: 5 }, timeout: 8
      )
      @bills = bills_response.success? ? (bills_response.parsed_response["results"] || []) : []
    rescue
      @bills = []
    end

    identifiers  = @bills.map { |b| b["identifier"] }
    @bill_id_map = CivicBill.where(identifier: identifiers, jurisdiction: "pennsylvania").pluck(:identifier, :id).to_h
    @bills_active   = @bills.select { |b| CivicBill::ACTIVE_STAGES.include?(CivicBill.classify_stage(b["latest_action_description"].to_s)) }
    @bills_resolved = @bills.reject { |b| CivicBill::ACTIVE_STAGES.include?(CivicBill.classify_stage(b["latest_action_description"].to_s)) }
    @finance = nil
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
