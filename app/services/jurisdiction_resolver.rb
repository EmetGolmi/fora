class JurisdictionResolver
  include HTTParty

  GEOCODER_URI = "https://geocoding.geo.census.gov/geocoder/locations/onelineaddress"
  OPENSTATES_URI = "https://v3.openstates.org/people.geo"
  PHL_CARTO_URI = "https://phl.carto.com/api/v2/sql"

  def self.resolve(address)
    new.resolve(address)
  end

  def resolve(address)
    geo = geocode(address)
    return nil unless geo

    coords = geo[:coordinates]
    matched = geo[:matched_address]

    officials = fetch_officials(coords[:lat], coords[:lng])
    return nil unless officials

    if matched[:city]&.upcase == "PHILADELPHIA"
      officials += fetch_philadelphia_officials(coords[:lat], coords[:lng], matched[:zip])
    end

    {
      normalized_address: matched[:full],
      city: matched[:city],
      state: matched[:state],
      zip: matched[:zip],
      officials: officials
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

  def fetch_officials(lat, lng)
    response = self.class.get(OPENSTATES_URI, query: {
      lat: lat,
      lng: lng
    }, headers: { "X-API-KEY" => api_key })

    return nil unless response.success?

    results = response.parsed_response["results"] || []
    results.map { |person| normalize_official(person) }
  end

  def normalize_official(person)
    current_role = (person["current_role"] || {})

    {
      name: person["name"],
      office: current_role["title"],
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

  PHL_ZIP_TO_DISTRICT = {
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

  def fetch_philadelphia_officials(lat, lng, zip)
    citywide = fetch_phl_citywide_officials
    district_member = fetch_phl_district_official(zip)

    citywide + district_member
  end

  def fetch_phl_citywide_officials
    sql = "SELECT first_name, last_name, office, office_label, district, party " \
          "FROM elected_officials WHERE office IN ('mayor', 'city_council_at_large')"

    response = self.class.get(PHL_CARTO_URI, query: { q: sql })
    return [] unless response.success?

    rows = response.parsed_response["rows"] || []
    rows.map { |row| normalize_phl_official(row) }
  end

  def fetch_phl_district_official(zip)
    district = PHL_ZIP_TO_DISTRICT[zip.to_s]
    return [] unless district

    sql = "SELECT first_name, last_name, office, office_label, district, party " \
          "FROM elected_officials WHERE office = 'city_council' AND district = #{district.to_i}"

    response = self.class.get(PHL_CARTO_URI, query: { q: sql })
    return [] unless response.success?

    rows = response.parsed_response["rows"] || []
    rows.map { |row| normalize_phl_official(row) }
  end

  def normalize_phl_official(row)
    {
      name: [row["first_name"], row["last_name"]].compact.join(" "),
      office: row["office_label"],
      party: row["party"],
      jurisdiction: {
        name: row["office"],
        district: row["district"]&.to_s,
        division_id: "ocd-division/country:us/state:pa/place:philadelphia"
      }
    }
  end
end
