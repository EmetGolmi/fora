class JurisdictionResolver
  include HTTParty

  GEOCODING_URI  = "https://maps.googleapis.com/maps/api/geocode/json"
  OPENSTATES_URI = "https://v3.openstates.org/people.geo"
  CONGRESS_URI   = "https://api.congress.gov/v3/member"
  PHL_CARTO_URI  = "https://phl.carto.com/api/v2/sql"

  def self.resolve(address)
    new.resolve(address)
  end

  def resolve(address)
    geo = geocode(address)
    return nil unless geo

    coords  = geo[:coordinates]
    matched = geo[:matched_address]
    zip     = matched[:zip].to_s

    is_philly = matched[:city].to_s.upcase == "PHILADELPHIA" ||
                PHILLY_PA02_ZIPS.include?(zip) ||
                PHILLY_PA03_ZIPS.include?(zip)

    unless is_philly
      return {
        normalized_address: matched[:full],
        city:               matched[:city],
        state:              matched[:state],
        zip:                zip,
        not_covered:        true,
        message:            "FORA currently covers Philadelphia, PA. More cities coming soon.",
        officials:          []
      }
    end

    # Philadelphia — hardcoded federal + state officials + best-effort dynamic
    federal_officials = federal_executives + hardcoded_philly_federal_officials(zip)
    state_hardcoded   = hardcoded_philly_state_officials(zip)

    state_dynamic = begin
      fetch_state_officials(coords[:lat], coords[:lng]) || []
    rescue StandardError
      Rails.logger.warn("[JurisdictionResolver] OpenStates failed for #{coords.inspect}: #{$!.message}")
      []
    end

    state_officials = (state_hardcoded + state_dynamic).uniq { |o| o[:name].to_s.downcase.strip }

    city_officials = begin
      fetch_philadelphia_officials(coords[:lat], coords[:lng], zip)
    rescue StandardError
      []
    end

    officials = (federal_officials + state_officials + city_officials)
                .uniq { |o| o[:name].to_s.downcase.strip }

    {
      normalized_address: matched[:full],
      city:               matched[:city],
      state:              matched[:state],
      zip:                zip,
      officials:          officials
    }
  end

  private

  def geocode(address)
    response = self.class.get(GEOCODING_URI, query: {
      address: address,
      key:     ENV["GOOGLE_GEOCODING_API_KEY"]
    })

    return nil unless response.success?
    return nil unless response.parsed_response["status"] == "OK"

    result = response.parsed_response.dig("results", 0)
    return nil unless result

    components = result["address_components"] || []
    city  = component_long(components, "locality") ||
            component_long(components, "sublocality_level_1") ||
            component_long(components, "neighborhood")
    state = component_short(components, "administrative_area_level_1")
    zip   = component_long(components, "postal_code")
    lat   = result.dig("geometry", "location", "lat")
    lng   = result.dig("geometry", "location", "lng")

    {
      coordinates:     { lat: lat, lng: lng },
      matched_address: {
        full:  result["formatted_address"],
        city:  city,
        state: state,
        zip:   zip
      }
    }
  end

  def component_long(components, type)
    components.find { |c| c["types"].include?(type) }&.dig("long_name")
  end

  def component_short(components, type)
    components.find { |c| c["types"].include?(type) }&.dig("short_name")
  end

  def fetch_state_officials(lat, lng)
    response = self.class.get(OPENSTATES_URI, query: {
      lat:    lat,
      lng:    lng,
      apikey: ENV["OPENSTATES_API_KEY"]
    })

    return nil unless response.success?

    results = response.parsed_response["results"] || []
    all = results.map { |person| normalize_official(person) }

    all.reject do |official|
      division_id = official.dig(:jurisdiction, :division_id).to_s
      jur_name    = official.dig(:jurisdiction, :name).to_s

      division_id.include?("/cd:") ||
        (jur_name == "upper" && !division_id.include?("sldu"))
    end
  end

  def fetch_federal_officials(state, zip)
    congress_api_key = ENV["CONGRESS_API_KEY"]
    return [] unless congress_api_key

    state_code = state.to_s.upcase.presence || "PA"

    response = self.class.get("#{CONGRESS_URI}/#{state_code}", query: {
      currentMember: true,
      api_key:       congress_api_key,
      limit:         50
    })

    return [] unless response.success?

    members          = response.parsed_response.dig("members") || []
    congress_district = PHL_ZIP_TO_CONGRESS_DISTRICT[zip.to_s]

    senators = members.select { |m| m.dig("terms", "item")&.last&.dig("chamber") == "Senate" }
    representatives = if congress_district
      members.select do |m|
        last_term = m.dig("terms", "item")&.last
        last_term&.dig("chamber") == "House of Representatives" &&
          m["district"].to_i == congress_district.to_i
      end
    else
      []
    end

    (senators + representatives).map { |m| normalize_congress_member(m) }
  end

  def normalize_congress_member(member)
    chamber     = member.dig("terms", "item")&.last&.dig("chamber")
    district    = member["district"]
    name        = format_congress_name(member["name"])
    bioguide_id = member["bioguideId"]

    if chamber == "Senate"
      {
        name:         name,
        office:       "U.S. Senator",
        party:        member["partyName"],
        jurisdiction: { name: "us_senate", district: nil, division_id: "ocd-division/country:us/state:pa", bioguide_id: bioguide_id }
      }
    else
      {
        name:         name,
        office:       "U.S. Representative, Congressional District #{district}",
        party:        member["partyName"],
        jurisdiction: { name: "us_house", district: district.to_s, division_id: "ocd-division/country:us/state:pa/cd:#{district}", bioguide_id: bioguide_id }
      }
    end
  end

  def format_congress_name(name)
    return name unless name&.include?(",")
    parts = name.split(",", 2).map(&:strip)
    "#{parts[1]} #{parts[0]}"
  end

  def normalize_official(person)
    current_role = (person["current_role"] || {})
    division_id  = current_role["division_id"].to_s
    title        = current_role["title"].to_s

    office = if division_id.include?("sldl") && title == "Representative"
      "State Representative"
    elsif division_id.include?("sldu") && title == "Senator"
      "State Senator"
    else
      title
    end

    {
      name:         person["name"],
      office:       office,
      party:        person["party"],
      jurisdiction: build_jurisdiction(current_role, person["id"])
    }
  end

  def build_jurisdiction(role, openstates_id = nil)
    {
      name:          role["org_classification"],
      district:      role["district"],
      division_id:   role["division_id"],
      openstates_id: openstates_id
    }
  end

  def federal_executives
    [
      {
        name:         "Donald Trump",
        office:       "President of the United States",
        party:        "Republican",
        jurisdiction: { name: "president", district: nil, division_id: "ocd-division/country:us" }
      },
      {
        name:         "JD Vance",
        office:       "Vice President of the United States",
        party:        "Republican",
        jurisdiction: { name: "vice_president", district: nil, division_id: "ocd-division/country:us" }
      }
    ]
  end

  def fetch_philadelphia_officials(lat, lng, zip)
    statewide       = fetch_phl_statewide_officials
    citywide        = fetch_phl_citywide_officials
    council_district = fetch_phl_council_district_official(zip)

    statewide + citywide + council_district
  end

  def fetch_phl_statewide_officials
    sql = "SELECT first_name, last_name, office, office_label, district, party " \
          "FROM elected_officials WHERE office IN ('governor', 'lt_governor')"

    response = self.class.get(PHL_CARTO_URI, query: { q: sql })
    return [] unless response.success?

    (response.parsed_response["rows"] || []).map { |row| normalize_phl_official(row) }
  end

  PHILLY_APPOINTED = [
    { name: 'Adam Thiel', office: 'Managing Director', party: nil,
      jurisdiction: { name: 'managing_director', district: nil,
                      division_id: 'ocd-division/country:us/state:pa/place:philadelphia' } },
    { name: 'Rob Dubow',  office: 'Director of Finance', party: nil,
      jurisdiction: { name: 'finance_director', district: nil,
                      division_id: 'ocd-division/country:us/state:pa/place:philadelphia' } }
  ].freeze

  def fetch_phl_citywide_officials
    sql = "SELECT first_name, last_name, office, office_label, district, party " \
          "FROM elected_officials WHERE office IN ('mayor', 'city_council_at_large')"

    response = self.class.get(PHL_CARTO_URI, query: { q: sql })
    elected  = response.success? ? (response.parsed_response["rows"] || []).map { |row| normalize_phl_official(row) } : []

    mayor    = elected.select { |o| o[:jurisdiction][:name] == 'mayor' }
    at_large = elected.reject { |o| o[:jurisdiction][:name] == 'mayor' }
    mayor + PHILLY_APPOINTED + at_large
  end

  def fetch_phl_council_district_official(zip)
    district = PHL_ZIP_TO_COUNCIL_DISTRICT[zip.to_s]
    return [] unless district

    sql = "SELECT first_name, last_name, office, office_label, district, party " \
          "FROM elected_officials WHERE office = 'city_council' AND district = #{district.to_i}"

    response = self.class.get(PHL_CARTO_URI, query: { q: sql })
    return [] unless response.success?

    (response.parsed_response["rows"] || []).map { |row| normalize_phl_official(row) }
  end

  OFFICE_LABELS = {
    "us_senate"   => "U.S. Senator",
    "us_house"    => "U.S. Representative",
    "governor"    => "Governor",
    "lt_governor" => "Lieutenant Governor"
  }.freeze

  PARTY_LABELS = {
    "D" => "Democratic",
    "R" => "Republican",
    "W" => "Working Families",
    "I" => "Independent"
  }.freeze

  def normalize_phl_official(row)
    office = row["office"]
    division_id = case office
    when "us_senate"              then "ocd-division/country:us/state:pa"
    when "us_house"               then "ocd-division/country:us/state:pa/cd:#{row['district']}"
    when "governor", "lt_governor" then "ocd-division/country:us/state:pa"
    else                               "ocd-division/country:us/state:pa/place:philadelphia"
    end

    raw_party = row["party"].to_s.strip
    label     = OFFICE_LABELS[office] || row["office_label"]

    {
      name:         [row["first_name"], row["last_name"]].compact.join(" "),
      office:       label,
      party:        PARTY_LABELS[raw_party] || raw_party,
      jurisdiction: {
        name:        office,
        district:    row["district"]&.to_s,
        division_id: division_id
      }
    }
  end

  PHILLY_PA02_ZIPS = %w[
    19114 19115 19116 19120 19124 19135 19136 19137 19138 19149 19152 19154
  ].freeze

  PHILLY_PA03_ZIPS = %w[
    19102 19103 19104 19106 19107 19108 19109 19110 19111 19118 19119
    19121 19122 19123 19125 19126 19127 19128 19129 19130 19131 19132
    19133 19134 19139 19140 19141 19142 19143 19144 19145 19146 19147
    19148 19150 19151 19153
  ].freeze

  def hardcoded_philly_federal_officials(zip)
    district = if PHILLY_PA02_ZIPS.include?(zip)
      "2"
    elsif PHILLY_PA03_ZIPS.include?(zip)
      "3"
    end

    senators = [
      { name: "John Fetterman", office: "U.S. Senator", party: "Democratic",
        jurisdiction: { name: "us_senate", district: nil,
                        division_id: "ocd-division/country:us/state:pa",
                        bioguide_id: "F000479" } },
      { name: "Dave McCormick", office: "U.S. Senator", party: "Republican",
        jurisdiction: { name: "us_senate", district: nil,
                        division_id: "ocd-division/country:us/state:pa",
                        bioguide_id: "M001243" } }
    ]

    rep = case district
    when "2"
      { name: "Brendan Boyle",
        office: "U.S. Representative, Congressional District 2",
        party: "Democratic",
        jurisdiction: { name: "us_house", district: "2",
                        division_id: "ocd-division/country:us/state:pa/cd:2",
                        bioguide_id: "B001296" } }
    when "3"
      { name: "Dwight Evans",
        office: "U.S. Representative, Congressional District 3",
        party: "Democratic",
        jurisdiction: { name: "us_house", district: "3",
                        division_id: "ocd-division/country:us/state:pa/cd:3",
                        bioguide_id: "E000296" } }
    end

    rep ? senators + [rep] : senators
  end

  # Saval (SD-1) and Waxman (HD-182) serve South Philly / Center City — all PA-03 zips.
  # Hardcoded because OpenStates people.geo returns 429 rate-limit errors in production.
  def hardcoded_philly_state_officials(zip)
    return [] unless PHILLY_PA03_ZIPS.include?(zip)

    [
      { name: "Nikil Saval",
        office: "State Senator",
        party: "D",
        jurisdiction: { name: "upper", district: "1",
                        division_id: "ocd-division/country:us/state:pa/sldu:1",
                        openstates_id: "ocd-person/6f172bc8-50b0-4dd3-aed6-b5fd48b70eeb" } },
      { name: "Ben Waxman",
        office: "State Representative",
        party: "D",
        jurisdiction: { name: "lower", district: "182",
                        division_id: "ocd-division/country:us/state:pa/sldl:182",
                        openstates_id: "ocd-person/1f2c3093-8ce7-41f7-8df0-6cd14ddd354b" } }
    ]
  end

  PHL_ZIP_TO_COUNCIL_DISTRICT = {
    "19102" => 5, "19103" => 8, "19106" => 1, "19107" => 5,
    "19122" => 7, "19123" => 5, "19125" => 7, "19127" => 3,
    "19128" => 3, "19129" => 8, "19130" => 8, "19131" => 3,
    "19132" => 8, "19133" => 7, "19134" => 7, "19135" => 10,
    "19136" => 10, "19137" => 1, "19138" => 8, "19139" => 3,
    "19140" => 7, "19141" => 8, "19142" => 3, "19143" => 3,
    "19144" => 8, "19145" => 2, "19146" => 2, "19147" => 2,
    "19148" => 2, "19149" => 10, "19150" => 8, "19151" => 3,
    "19152" => 10, "19153" => 2, "19154" => 10
  }.freeze

  PHL_ZIP_TO_CONGRESS_DISTRICT = {
    "19102" => 5, "19103" => 3, "19106" => 3, "19107" => 5,
    "19122" => 2, "19123" => 5, "19125" => 2, "19126" => 2,
    "19127" => 3, "19128" => 3, "19129" => 2, "19130" => 2,
    "19131" => 3, "19132" => 2, "19133" => 2, "19134" => 2,
    "19135" => 3, "19136" => 3, "19137" => 2, "19138" => 2,
    "19139" => 3, "19140" => 2, "19141" => 2, "19142" => 3,
    "19143" => 3, "19144" => 2, "19145" => 2, "19146" => 3,
    "19147" => 3, "19148" => 3, "19149" => 3, "19150" => 2,
    "19151" => 3, "19152" => 3, "19153" => 3, "19154" => 3
  }.freeze
end
