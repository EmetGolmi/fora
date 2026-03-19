class CongressSocialService
  include HTTParty
  base_uri "https://raw.githubusercontent.com"

  SOCIAL_MEDIA_PATH = "/unitedstates/congress-legislators/main/legislators-social-media.yaml"

  @legislators = nil

  def self.for_bioguide(bioguide_id)
    entry = legislators.find { |l| l.dig("id", "bioguide") == bioguide_id }
    return {} unless entry

    social = entry["social"] || {}

    {
      twitter: social["twitter"],
      facebook: social["facebook"],
      instagram: social["instagram"],
      youtube: social["youtube"],
      website: social["website"]
    }
  rescue => e
    Rails.logger.error("CongressSocialService: failed to look up #{bioguide_id}: #{e.message}")
    {}
  end

  def self.legislators
    @legislators ||= fetch_legislators
  end

  def self.fetch_legislators
    response = get(SOCIAL_MEDIA_PATH)
    return [] unless response.success?

    YAML.safe_load(response.body, permitted_classes: [Date]) || []
  rescue => e
    Rails.logger.error("CongressSocialService: failed to fetch social media data: #{e.message}")
    []
  end

  private_class_method :fetch_legislators
end
