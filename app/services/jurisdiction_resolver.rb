class JurisdictionResolver
  include HTTParty

  GEOCODER_URI = "https://geocoding.geo.census.gov/geocoder/locations/onelineaddress"
  OPENSTATES_URI = "https://v3.openstates.org/people.geo"
  CONGRESS_URI = "https://api.congress.gov/v3/member"
  PHL_CARTO_URI = "https://phl.carto.com/api/v2/sql"

  def self.resolve(address)
    new.resolve(address)
  end

  def resolve(address)
    geo = geocode(address)
    return nil unless geo

    coords = geo[:coordinates]
    matched = geo[:matched_address]

    state_officials = fetch_state_officials(coords[:lat], coords[:lng])
    return nil unless state_officials

    federal = federal_executives + fetch_federal_officials(matched[:zip])

    officials = federal + state_officials

    if matched[:city]&.upcase == "PHILADELPHIA"
      officials += fetch_philadelphia_officials(coords[:lat], coords[:lng], matched[:zip])
    end

    {
      normalized_address: matched[:full],
      city: matched[:city],
      state: matched[:state],
      zip: matched[:zip],
      officials: officials.uniq { |o| o[:name].to_s.downcase.strip }
    }
  end

  private

  def api_key
    ENV["OPENSTATES_API_KEY"]
  end

  def geocode(address)
    response = self.class.get(GEOCODER_URI, query: {
      address: address,
      benchmark: "Public_AR_Current",
      format: "json"
    })

    return nil unless response.success?

    match = response.dig("result", "addressMatches", 0)
    return nil unless match

    {
      coordinates: {
        lat: match.dig("coordinates", "y"),
        lng: match.dig("coordinates", "x")
      },
      matched_address: {
        full: match["matchedAddress"],
        city: match.dig("addressComponents", "city"),
        state: match.dig("addressComponents", "state"),
        zip: match.dig("addressComponents", "zip")
      }
    }
  end

  def fetch_state_officials(lat, lng)
    response = self.class.get(OPENSTATES_URI, query: {
      lat: lat,
      lng: lng
    }, headers: { "X-API-KEY" => api_key })

    return nil unless response.success?

    results = response.parsed_response["results"] || []
    all = results.map { |person| normalize_official(person) }

    all.reject do |official|
      division_id = official.dig(:jurisdiction, :division_id).to_s
      jur_name = official.dig(:jurisdiction, :name).to_s

      division_id.include?("/cd:") ||
        (jur_name == "upper" && !division_id.include?("sldu"))
    end
  end

  def fetch_federal_officials(zip)
    congress_api_key = ENV["CONGRESS_API_KEY"]
    return [] unless congress_api_key

    response = self.class.get("#{CONGRESS_URI}/PA", query: {
      currentMember: true,
      api_key: congress_api_key,
      limit: 50
    })

    return [] unless response.success?

    members = response.parsed_response.dig("members") || []
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
    chamber = member.dig("terms", "item")&.last&.dig("chamber")
    district = member["district"]
    name = format_congress_name(member["name"])

    if chamber == "Senate"
      {
        name: name,
        office: "U.S. Senator",
        party: member["partyName"],
        jurisdiction: { name: "us_senate", district: nil, division_id: "ocd-division/country:us/state:pa" }
      }
    else
      {
        name: name,
        office: "U.S. Representative, Congressional District #{district}",
        party: member["partyName"],
        jurisdiction: { name: "us_house", district: district.to_s, division_id: "ocd-division/country:us/state:pa/cd:#{district}" }
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

    division_id = current_role["division_id"].to_s
    title = current_role["title"].to_s
    office = if division_id.include?("sldl") && title == "Representative"
      "State Representative"
    elsif division_id.include?("sldu") && title == "Senator"
      "State Senator"
    else
      title
    end

    {
      name: person["name"],
      office: office,
      party: person["party"],
      jurisdiction: build_jurisdiction(current_role)
    }
  end

  def build_jurisdiction(role)
    {
      name: role.dig("org_classification"),
      district: role["district"],
      division_id: role["division_id"]
    }
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

  def fetch_philadelphia_officials(lat, lng, zip)
    statewide = fetch_phl_statewide_officials
    citywide = fetch_phl_citywide_officials
    council_district = fetch_phl_council_district_official(zip)

    statewide + citywide + council_district
  end

  def federal_executives
    [
      {
        name: "Donald Trump",
        office: "President of the United States",
        party: "Republican",
        jurisdiction: { name: "federal", district: nil, division_id: "ocd-division/country:us" }
      },
      {
        name: "JD Vance",
        office: "Vice President of the United States",
        party: "Republican",
        jurisdiction: { name: "federal", district: nil, division_id: "ocd-division/country:us" }
      }
    ]
  end

  def fetch_phl_statewide_officials
    sql = "SELECT first_name, last_name, office, office_label, district, party " \
          "FROM elected_officials WHERE office IN ('governor', 'lt_governor')"

    response = self.class.get(PHL_CARTO_URI, query: { q: sql })
    return [] unless response.success?

    (response.parsed_response["rows"] || []).map { |row| normalize_phl_official(row) }
  end

  def fetch_phl_citywide_officials
    sql = "SELECT first_name, last_name, office, office_label, district, party " \
          "FROM elected_officials WHERE office IN ('mayor', 'city_council_at_large')"

    response = self.class.get(PHL_CARTO_URI, query: { q: sql })
    return [] unless response.success?

    rows = response.parsed_response["rows"] || []
    rows.map { |row| normalize_phl_official(row) }
  end

  def fetch_phl_council_district_official(zip)
    district = PHL_ZIP_TO_COUNCIL_DISTRICT[zip.to_s]
    return [] unless district

    sql = "SELECT first_name, last_name, office, office_label, district, party " \
          "FROM elected_officials WHERE office = 'city_council' AND district = #{district.to_i}"

    response = self.class.get(PHL_CARTO_URI, query: { q: sql })
    return [] unless response.success?

    rows = response.parsed_response["rows"] || []
    rows.map { |row| normalize_phl_official(row) }
  end

  OFFICE_LABELS = {
    "us_senate" => "U.S. Senator",
    "us_house" => "U.S. Representative",
    "governor" => "Governor",
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
    when "us_senate"
      "ocd-division/country:us/state:pa"
    when "us_house"
      "ocd-division/country:us/state:pa/cd:#{row['district']}"
    when "governor", "lt_governor"
      "ocd-division/country:us/state:pa"
    else
      "ocd-division/country:us/state:pa/place:philadelphia"
    end

    raw_party = row["party"].to_s.strip
    label = OFFICE_LABELS[office] || row["office_label"]

    {
      name: [row["first_name"], row["last_name"]].compact.join(" "),
      office: label,
      party: PARTY_LABELS[raw_party] || raw_party,
      jurisdiction: {
        name: office,
        district: row["district"]&.to_s,
        division_id: division_id
      }
    }
  end
end
