class OfficialsController < ApplicationController
  include HTTParty
  base_uri "https://api.congress.gov/v3"

  WIKI_FILENAMES = {
    "F000479" => "John_Fetterman_official_portrait.jpg",
    "M001243" => "McCormick_Portrait_(HR).jpg",
    "E000296" => "Dwight_Evans_official_photo_(cropped).jpg",
    "nsaval"  => "Nikil_Saval_press_conference.jpg",
    "bwaxman" => "WaxmanSpeaking32BJ_(cropped).jpg"
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
    },
    "nsaval" => {
      "bioguideId"       => "nsaval",
      "directOrderName"  => "Nikil Saval",
      "name"             => "Saval, Nikil",
      "partyName"        => "Democratic",
      "officialWebsiteUrl" => "https://www.senatornikils.com",
      "terms"            => [{ "chamber" => "PA Senate", "district" => "1", "startYear" => 2022 }],
      "depiction"        => { "imageUrl" => nil },
      "addressInformation" => { "officeAddress" => "Senate Box 203001, Harrisburg PA 17120", "phoneNumber" => "(215) 952-4766" }
    },
    "bwaxman" => {
      "bioguideId"       => "bwaxman",
      "directOrderName"  => "Ben Waxman",
      "name"             => "Waxman, Ben",
      "partyName"        => "Democratic",
      "officialWebsiteUrl" => "https://www.pahouse.com/waxman",
      "terms"            => [{ "chamber" => "PA House", "district" => "182", "startYear" => 2023 }],
      "depiction"        => { "imageUrl" => nil },
      "addressInformation" => { "officeAddress" => "42B East Wing, Harrisburg PA 17120", "phoneNumber" => "(215) 463-5269" }
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

  BILL_TOTALS = {
    "F000479" => { sponsored: 35,  cosponsored: 760 },
    "M001243" => { sponsored: 40,  cosponsored: 170 },
    "E000296" => { sponsored: 10,  cosponsored: 350 },
    "nsaval"  => { sponsored: 25,  cosponsored: 90 },
    "bwaxman" => { sponsored: 15,  cosponsored: 55 }
  }.freeze

  # 119th Congress stats (Jan 2025 – present)
  BILL_STATS_119 = {
    "F000479" => { enacted: 0, in_committee: 33, votes_cast_119: "~700 of 733" },
    "M001243" => { enacted: 2, in_committee: 38, votes_cast_119: "~713 of 733",
                   enacted_bills: [
                     { number: "S. 1780", title: "Mexico Security Assistance Accountability Act",
                       summary: "Establishes accountability and oversight mechanisms for U.S. security assistance funds provided to Mexico, ensuring resources are directed toward combating drug trafficking and cartel violence." },
                     { number: "S. 1900", title: "Taiwan Non-Discrimination Act of 2025",
                       summary: "Affirms U.S. policy supporting Taiwan's meaningful participation in international organizations and opposing diplomatic efforts to exclude or diminish Taiwan's international standing." }
                   ] },
    "E000296" => { enacted: 0, in_committee: 10, votes_cast_119: "~420 of 430" },
    "nsaval"  => { enacted: 1, in_committee: 5, votes_cast_119: "~850 of 890",
                   enacted_bills: [
                     { number: "SB 4", title: "Whole-Home Repairs Program",
                       summary: "Established a $125 million statewide program for home rehabilitation grants and low-interest loans for low-income homeowners — addressing critical repairs including roofing, plumbing, and electrical systems. Enacted 2025." }
                   ] },
    "bwaxman" => { enacted: 0, in_committee: 4, votes_cast_119: "~1,100 of 1,150" }
  }.freeze

  NEWS_QUERIES = {
    "F000479" => '"John Fetterman" senator Pennsylvania',
    "M001243" => '"Dave McCormick" senator Pennsylvania',
    "E000296" => '"Dwight Evans" congressman Philadelphia',
    "B001296" => '"Brendan Boyle" congressman Pennsylvania',
    "nsaval"  => '"Nikil Saval" senator Philadelphia',
    "bwaxman" => '"Ben Waxman" representative Philadelphia'
  }.freeze

  HARDCODED_BILLS = {
    "F000479" => [
      { "type" => "S", "number" => "4045", "title" => "Food and Nutrition Delivery Safety Act of 2026",
        "latestAction" => { "text" => "Read twice and referred to the Committee on Agriculture, Nutrition, and Forestry.", "actionDate" => "2026-03-10" } },
      { "type" => "S", "number" => "3903", "title" => "Railway Safety Act of 2026",
        "latestAction" => { "text" => "Read twice and referred to the Committee on Commerce, Science, and Transportation.", "actionDate" => "2026-02-26" } },
      { "type" => "S", "number" => "3796", "title" => "Ohio River Restoration Program Act of 2026",
        "latestAction" => { "text" => "Read twice and referred to the Committee on Environment and Public Works.", "actionDate" => "2026-02-05" } },
      { "type" => "S", "number" => "3733", "title" => "A bill to authorize public libraries to collect and retain a fee for passport application execution",
        "latestAction" => { "text" => "Read twice and referred to the Committee on Foreign Relations.", "actionDate" => "2026-01-29" } },
      { "type" => "S", "number" => "3660", "title" => "Credit Card Fairness Act",
        "latestAction" => { "text" => "Read twice and referred to the Committee on Banking, Housing, and Urban Affairs.", "actionDate" => "2026-01-15" } },
      { "type" => "S", "number" => "3468", "title" => "National Programmable Cloud Laboratories Network Act of 2025",
        "latestAction" => { "text" => "Read twice and referred to the Committee on Commerce, Science, and Transportation.", "actionDate" => "2025-12-11" } },
      { "type" => "S", "number" => "2929", "title" => "Consistent Egg Labels Act of 2025",
        "latestAction" => { "text" => "Read twice and referred to the Committee on Health, Education, Labor, and Pensions.", "actionDate" => "2025-09-29" } }
    ].freeze,
    "M001243" => [
      { "type" => "S", "number" => "4238", "title" => "A bill to designate the Endless Mountains National Heritage Area in Pennsylvania as a component of the National Heritage Area System",
        "latestAction" => { "text" => "Read twice and referred to the Committee on Energy and Natural Resources.", "actionDate" => "2026-03-26" } },
      { "type" => "S", "number" => "3947", "title" => "Reconductoring Existing Wires for Infrastructure Reliability and Expansion (REWIRE) Act",
        "latestAction" => { "text" => "Read twice and referred to the Committee on Energy and Natural Resources.", "actionDate" => "2026-02-26" } },
      { "type" => "S", "number" => "3900", "title" => "Iran Human Rights, Internet Freedom, and Accountability Act of 2026",
        "latestAction" => { "text" => "Read twice and referred to the Committee on Foreign Relations.", "actionDate" => "2026-02-24" } },
      { "type" => "S", "number" => "3835", "title" => "A bill to designate the USPS facility in Mahaffey, Pennsylvania, as the Robert Allen Bishop, Sr., Post Office Building",
        "latestAction" => { "text" => "Read twice and referred to the Committee on Homeland Security and Governmental Affairs.", "actionDate" => "2026-02-11" } },
      { "type" => "S", "number" => "2626", "title" => "Strengthening United States Leadership at the IDB Act",
        "latestAction" => { "text" => "Ordered to be reported favorably by the Senate Foreign Relations Committee.", "actionDate" => "2025-10-24" } },
      { "type" => "S", "number" => "2044", "title" => "Office of Fossil Energy and Carbon Management Relocation Act of 2025",
        "latestAction" => { "text" => "Read twice and referred to the Committee on Energy and Natural Resources.", "actionDate" => "2025-06-12" } },
      { "type" => "S", "number" => "1739", "title" => "International Nuclear Energy Financing Act of 2025",
        "latestAction" => { "text" => "Read twice and referred to the Committee on Foreign Relations.", "actionDate" => "2025-05-13" } }
    ].freeze,
    "E000296" => [
      { "type" => "HR",   "number" => "7532", "title" => "To designate the USPS facility at 4431 Main Street in Philadelphia as the Dr. Constance E. Clayton Post Office",
        "latestAction" => { "text" => "Referred to the House Committee on Oversight and Government Reform.", "actionDate" => "2026-02-12" } },
      { "type" => "HRES", "number" => "1071", "title" => "Recognizing the desegregation of Girard College in Philadelphia and leaders of the civil rights movement",
        "latestAction" => { "text" => "Referred to the House Committee on the Judiciary.", "actionDate" => "2026-02-23" } },
      { "type" => "HRES", "number" => "898",  "title" => "Recognizing November 2025 as National Family Caregivers Month",
        "latestAction" => { "text" => "Referred to the House Committee on Energy and Commerce.", "actionDate" => "2025-11-05" } },
      { "type" => "HRES", "number" => "712",  "title" => "Expressing support for the designation of September 14, 2025, as National Food is Medicine Day",
        "latestAction" => { "text" => "Referred to the Committee on Energy and Commerce, and in addition to the Committee on Agriculture.", "actionDate" => "2025-09-11" } },
      { "type" => "HR",   "number" => "2764", "title" => "Tax Cut for Workers Act of 2025",
        "latestAction" => { "text" => "Referred to the House Committee on Ways and Means.", "actionDate" => "2025-04-09" } },
      { "type" => "HR",   "number" => "5383", "title" => "Mentoring and Supporting Families Act",
        "latestAction" => { "text" => "Referred to the House Committee on Ways and Means.", "actionDate" => "2025-07-24" } },
      { "type" => "HR",   "number" => "3681", "title" => "Leveraging Educational Opportunity Networks (LEON) Act",
        "latestAction" => { "text" => "Referred to the House Committee on Education and Workforce.", "actionDate" => "2025-05-15" } }
    ].freeze,
    "nsaval" => [
      { "type" => "SB", "number" => "601",  "title" => "Shelter First Act — bans criminalization of homelessness in Pennsylvania",
        "jurisdiction" => "pennsylvania",
        "latestAction" => { "text" => "In Committee · Urban Affairs & Housing", "actionDate" => "2026-01-15" } },
      { "type" => "SB", "number" => "4",    "title" => "Whole-Home Repairs Program — $125M for housing rehabilitation statewide",
        "jurisdiction" => "pennsylvania",
        "latestAction" => { "text" => "Signed into law — 2025", "actionDate" => "2025-07-01" } },
      { "type" => "SB", "number" => "900",  "title" => "Tenant Opportunity to Purchase Act — right of first refusal for renters facing sale",
        "jurisdiction" => "pennsylvania",
        "latestAction" => { "text" => "In Committee · 2026", "actionDate" => "2026-02-01" } }
    ].freeze,
    "bwaxman" => [
      { "type" => "HB", "number" => "1802", "title" => "Just Cause Eviction Act — requires landlords to cite legal cause for all evictions",
        "jurisdiction" => "pennsylvania",
        "latestAction" => { "text" => "In Committee · Housing & Community Development", "actionDate" => "2026-01-20" } },
      { "type" => "HB", "number" => "1420", "title" => "Fair Workweek Act — predictable scheduling for hourly workers in retail and food service",
        "jurisdiction" => "pennsylvania",
        "latestAction" => { "text" => "In Committee · Labor & Industry", "actionDate" => "2025-09-10" } },
      { "type" => "HB", "number" => "922",  "title" => "School Infrastructure Repair Fund — dedicated capital for aging school buildings",
        "jurisdiction" => "pennsylvania",
        "latestAction" => { "text" => "In Committee · Education", "actionDate" => "2025-06-05" } }
    ].freeze
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
    state_social = { "nsaval" => { twitter: "NikilSaval", instagram: "nikilsaval" } }[bioguide_id]
    @social.merge!(state_social) if state_social

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
                               query: { api_key: api_key, limit: 10, sort: "introducedDate+desc" })
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
        @recent_votes           = stats[:recent_votes] || []
      end
    end

    threads << Thread.new do
      begin
        news_q = NEWS_QUERIES[bioguide_id] || "\"#{member_name.split.last}\""
        news_resp = HTTParty.get("https://newsapi.org/v2/everything",
                                 query: { apiKey: ENV["NEWSAPI_KEY"], q: news_q,
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

    if HARDCODED_BILLS.key?(bioguide_id)
      is_state_official = %w[nsaval bwaxman].include?(bioguide_id)
      @bills = HARDCODED_BILLS[bioguide_id].map { |b| is_state_official ? b : b.merge("congress" => 119) }
      @bills.each do |bill|
        type = bill["type"].to_s.upcase
        prefix = bill_type_labels[type] || type
        bill["_identifier"]  = "#{prefix} #{bill['number']}"
        bill["_external_id"] = "#{type}-#{bill['number']}"
      end
      ActiveRecord::Base.connection_pool.with_connection do
        identifiers  = @bills.map { |b| b["_identifier"] }
        existing_map = CivicBill.where(identifier: identifiers).pluck(:identifier, :id).to_h
        unmatched    = @bills.reject { |b| existing_map.key?(b["_identifier"]) }
        if unmatched.any?
          now  = Time.current
          rows = unmatched.map do |bill|
            raw_status = bill.dig("latestAction", "text").to_s.presence
            { source:       is_state_official ? "pa_legislature" : "congress",
              external_id:  bill["_external_id"],
              identifier:   bill["_identifier"],
              title:        bill["title"].to_s,
              status:       raw_status,
              bill_stage:   CivicBill.classify_stage(raw_status),
              status_date:  (Date.parse(bill.dig("latestAction", "actionDate").to_s) rescue nil),
              jurisdiction: is_state_official ? "pennsylvania" : "federal",
              created_at:   now, updated_at: now }
          end
          CivicBill.upsert_all(rows, unique_by: %i[source external_id], update_only: %i[title status bill_stage status_date])
        end
        @bill_id_map = CivicBill.where(identifier: identifiers).pluck(:identifier, :id).to_h
      end
    end

    if (bt = BILL_TOTALS[bioguide_id])
      @total_bills_sponsored   = bt[:sponsored]
      @total_bills_cosponsored = bt[:cosponsored]
    end

    @bill_stats_119 = BILL_STATS_119[bioguide_id]

    fec_cand_id = FEC_IDS[bioguide_id]
    @finance = OfficialFinanceSummary.where(fec_candidate_id: fec_cand_id).order(cycle_year: :desc).first if fec_cand_id

    @social_handles = {
      "F000479" => { x: "SenJohnFetterman", instagram: "senjohnfetterman", youtube: nil,             website: "https://www.fetterman.senate.gov" },
      "M001243" => { x: "SenMcCormickPA",   instagram: "senmccormickpa",   youtube: "SenMcCormickPA", website: "https://www.mccormick.senate.gov" },
      "E000296" => { x: "RepDwightEvans",    instagram: "repdwightevans",   youtube: nil,             website: "https://evans.house.gov" },
      "B001296" => { x: "RepBrendanBoyle",   instagram: nil,                youtube: nil,             website: "https://boyle.house.gov" },
      "nsaval"  => { x: "NikilSaval",        instagram: "nikilsaval",       youtube: nil,             website: "https://www.senatornikils.com" },
      "bwaxman" => { x: nil,                 instagram: nil,                youtube: nil,             website: "https://www.pahouse.com/waxman" }
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

  def us_president
    @official     = Person.find_by!(slug: 'dtrump-us-president')
    @profile_type = :president
    render :show
  end

  def us_vp
    @official     = Person.find_by!(slug: 'jvance-us-vp')
    @profile_type = :vp
    render :show
  end

  def governor
    @official     = Person.find_by!(slug: 'jshapiro-pa-gov')
    @profile_type = :governor
    render :show
  end

  def lt_governor
    @official     = Person.find_by!(slug: 'adavis-pa-ltgov')
    @profile_type = :lt_governor
    render :show
  end

  def philly_mayor
    @official     = Person.find_by!(slug: 'cparker-philly-mayor')
    @profile_type = :mayor
    render :show
  end

  def philly_council_president
    @official = Person.find_by!(slug: 'kjohnson-phl-d2')
    @profile_type = :city_council
    render :show
  end

  def philly_majority_leader
    @official = Person.find_by!(slug: 'kgrichardson-phl-al')
    @profile_type = :city_council
    render :show
  end

  def philly_majority_whip
    @official = Person.find_by!(slug: 'ithomas-phl-al')
    @profile_type = :city_council
    render :show
  end

  def philly_minority_leader
    @official = Person.find_by!(slug: 'kbrooks-phl-al')
    @profile_type = :city_council
    render :show
  end

  def philly_minority_whip
    @official = Person.find_by!(slug: 'norourke-phl-al')
    @profile_type = :city_council
    render :show
  end

  def philly_deputy_majority_whip
    @official = Person.find_by!(slug: 'cbass-phl-d8')
    @profile_type = :city_council
    render :show
  end

  def philly_managing_director
    @official = Person.find_by!(slug: 'athiel-philly-md')
    @profile_type = :governor
    render :show
  end

  def philly_finance_director
    @official = Person.find_by!(slug: 'rdubow-philly-finance')
    @profile_type = :governor
    render :show
  end

  def philly_district_1;  @official = Person.find_by!(slug: 'msquilla-phl-d1');  @profile_type = :city_council; render :show; end
  def philly_district_2;  @official = Person.find_by!(slug: 'kjohnson-phl-d2');  @profile_type = :city_council; render :show; end
  def philly_district_3;  @official = Person.find_by!(slug: 'jgauthier-phl-d3'); @profile_type = :city_council; render :show; end
  def philly_district_4;  @official = Person.find_by!(slug: 'cjones-phl-d4');    @profile_type = :city_council; render :show; end
  def philly_district_5;  @official = Person.find_by!(slug: 'jyoung-phl-d5');    @profile_type = :city_council; render :show; end
  def philly_district_6;  @official = Person.find_by!(slug: 'mdriscoll-phl-d6'); @profile_type = :city_council; render :show; end
  def philly_district_7;  @official = Person.find_by!(slug: 'qlozada-phl-d7');   @profile_type = :city_council; render :show; end
  def philly_district_8;  @official = Person.find_by!(slug: 'cbass-phl-d8');     @profile_type = :city_council; render :show; end
  def philly_district_9;  @official = Person.find_by!(slug: 'aphillips-phl-d9'); @profile_type = :city_council; render :show; end
  def philly_district_10; @official = Person.find_by!(slug: 'boneill-phl-d10');  @profile_type = :city_council; render :show; end
  def philly_al_ahmad;    @official = Person.find_by!(slug: 'nahmad-phl-al');    @profile_type = :city_council; render :show; end
  def philly_al_harrity;  @official = Person.find_by!(slug: 'jharrity-phl-al');  @profile_type = :city_council; render :show; end
  def philly_al_landau;   @official = Person.find_by!(slug: 'rlandau-phl-al');   @profile_type = :city_council; render :show; end

  def philly_person
    slug = params[:slug].to_s.strip
    @official = Person.where(state: 'PA')
                      .find_by("slug = ? OR slug LIKE ?", slug, "#{slug}-%")
    render(file: 'public/404.html', status: :not_found, layout: false) and return unless @official
    @profile_type = case @official.office_type
                    when 'governor', 'lt_governor', 'attorney_general', 'managing_director', 'finance_director'
                      :governor
                    when 'city_council', 'city_council_at_large', 'mayor'
                      :city_council
                    else
                      @official.office_type.to_sym
                    end
    render :show
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
