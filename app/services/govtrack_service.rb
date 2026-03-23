class GovtrackService
  include HTTParty

  GOVTRACK_IDS = {
    "F000479" => "john_fetterman/456877",
    "M001243" => "david_mccormick/456963",
    "E000296" => "dwight_evans/412612"
  }.freeze

  BASE_URL = "https://www.govtrack.us/congress/members"

  def self.fetch(bioguide_id)
    slug = GOVTRACK_IDS[bioguide_id]
    return {} unless slug.present?

    new.fetch_member(slug)
  end

  def fetch_member(slug)
    response = self.class.get(
      "#{BASE_URL}/#{slug}",
      headers: { "User-Agent" => "FORA/1.0 (fora.center)" },
      follow_redirects: true
    )
    return {} unless response.success?

    doc = Nokogiri::HTML(response.body)
    {
      party_vote_pct:   extract_party_vote_pct(doc),
      missed_votes_pct: extract_missed_votes_pct(doc),
      committees:       extract_committees(doc)
    }
  rescue => e
    Rails.logger.warn "[GovtrackService] fetch failed for #{slug}: #{e.message}"
    {}
  end

  private

  # Party-line voting % is JS-rendered on GovTrack — not available via static scrape
  def extract_party_vote_pct(_doc)
    nil
  end

  # Matches: "missed 194 of 1,400 roll call votes, which is 13.9%."
  def extract_missed_votes_pct(doc)
    if doc.text =~ /missed \d[\d,]* of [\d,]+ roll call votes, which is ([\d\.]+)%/i
      $1.to_f
    end
  end

  def extract_committees(doc)
    committees = []
    # Try committee links first
    doc.css("a[href*='/congress/committees/']").each do |link|
      name = link.text.strip
      next if name.blank? || name.length < 10 || name.match?(/guess/i)
      committees << name
    end
    # Fallback: look for text containing "Committee"
    if committees.empty?
      doc.css("li, td, p").each do |el|
        text = el.text.strip
        next unless text.match?(/Committee/i) && text.length >= 10 && text.length < 120
        next if text.match?(/guess/i)
        committees << text
      end
    end
    committees.uniq.first(6)
  end
end
