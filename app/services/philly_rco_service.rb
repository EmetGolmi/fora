require "net/http"
require "uri"
require "json"

class PhillyRcoService
  ARCGIS_URL = "https://services.arcgis.com/fLeGjb7u4uXqeF9q/arcgis/rest/services/Zoning_RCO/FeatureServer/0/query"

  def self.for_coordinate(lat, lng)
    key    = "#{lat.to_f.round(5)},#{lng.to_f.round(5)}"
    cached = ResolvedRco.find_by(address_key: key)
    return cached.rco_data if cached

    rcos = new.fetch(lat, lng)
    ResolvedRco.upsert(
      { address_key: key, rco_data: rcos, fetched_at: Time.current,
        created_at: Time.current, updated_at: Time.current },
      unique_by: :address_key,
      update_only: %i[rco_data fetched_at]
    )
    rcos
  end

  def fetch(lat, lng)
    uri = URI(ARCGIS_URL)
    uri.query = URI.encode_www_form(
      geometry:     "#{lng},#{lat}",
      geometryType: "esriGeometryPoint",
      spatialRel:   "esriSpatialRelIntersects",
      inSR:         "4326",
      outSR:        "4326",
      outFields:    "*",
      f:            "json"
    )
    http          = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl  = true
    http.open_timeout = 6
    http.read_timeout = 8
    resp = http.get(uri.request_uri)
    return [] unless resp.is_a?(Net::HTTPSuccess)

    parsed   = JSON.parse(resp.body)
    features = parsed["features"] || []
    features.map { |f| normalize(f["attributes"] || {}) }.compact
  rescue => e
    Rails.logger.warn("[PhillyRcoService] ArcGIS fetch failed: #{e.message}")
    []
  end

  private

  def normalize(attrs)
    {
      "name"             => attrs["organization_name"],
      "address"          => attrs["organization_address"],
      "meeting_location" => attrs["meeting_location_address"],
      "primary_name"     => attrs["primary_name"],
      "primary_email"    => attrs["primary_email"],
      "primary_phone"    => attrs["primary_phone"],
      "website"          => attrs["websites"],
      "expiration_year"  => attrs["expirationyear"]
    }
  end
end
