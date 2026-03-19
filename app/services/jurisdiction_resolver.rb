class JurisdictionResolver
  include HTTParty

  GEOCODER_URI = "https://geocoding.geo.census.gov/geocoder/locations/onelineaddress"
  OPENSTATES_URI = "https://v3.openstates.org/people.geo"

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
end
