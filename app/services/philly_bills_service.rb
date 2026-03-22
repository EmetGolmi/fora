class PhillyBillsService
  include HTTParty

  BASE_URL = "https://phila.legistar.com"
  CALENDAR_URL = "#{BASE_URL}/Calendar.aspx"
  BILL_LIMIT = 50

  def self.sync_philly_bills
    new.sync_philly_bills
  end

  def sync_philly_bills
    bills = fetch_bills
    synced = 0
    failed = 0

    bills.each do |bill|
      CivicBill.upsert(bill, unique_by: [:source, :external_id])
      synced += 1
    rescue => e
      Rails.logger.error("PhillyBillsService: failed to sync bill #{bill[:external_id]}: #{e.message}")
      failed += 1
    end

    { synced: synced, failed: failed }
  end

  private

  def fetch_bills
    meeting_urls = find_recent_council_meetings(5)
    return [] if meeting_urls.empty?

    seen_file_numbers = Set.new
    bills = []

    meeting_urls.each do |meeting_url|
      legislation_urls = find_legislation_links(meeting_url)
      legislation_urls.each do |url|
        break if bills.size >= BILL_LIMIT
        bill = fetch_bill_detail(url) rescue nil
        next unless bill
        next if seen_file_numbers.include?(bill[:external_id])
        seen_file_numbers << bill[:external_id]
        bills << bill
      end
    end

    bills
  end

  # Step 1 — find the N most recent City Council meetings (not Committee of the Whole)

  def find_recent_council_meetings(limit = 5)
    response = self.class.get(CALENDAR_URL)
    unless response.success?
      Rails.logger.error("PhillyBillsService: Calendar.aspx returned #{response.code}")
      return []
    end

    doc  = Nokogiri::HTML(response.body)
    urls = []

    doc.css("a[href*='MeetingDetail']").each do |link|
      break if urls.size >= limit
      row_text = link.ancestors("tr").first&.text || ""
      next if row_text.match?(/committee of the whole/i)
      next unless row_text.match?(/city council/i)

      href = link["href"]
      urls << (href.start_with?("http") ? href : "#{BASE_URL}/#{href.sub(/\A\//, '')}").gsub("|", "%7C")
    end

    Rails.logger.warn("PhillyBillsService: no City Council meetings found on Calendar.aspx") if urls.empty?
    urls
  end

  # Step 2 — collect LegislationDetail links from the meeting page

  def find_legislation_links(meeting_url)
    response = self.class.get(meeting_url)
    unless response.success?
      Rails.logger.error("PhillyBillsService: meeting page #{meeting_url} returned #{response.code}")
      return []
    end

    doc = Nokogiri::HTML(response.body)
    doc.css("a[href*='LegislationDetail']").map do |link|
      href = link["href"]
      href.start_with?("http") ? href : "#{BASE_URL}/#{href.sub(/\A\//, '')}"
    end.uniq
  end

  # Step 3 — scrape an individual bill detail page

  def fetch_bill_detail(url)
    response = self.class.get(url)
    unless response.success?
      Rails.logger.warn("PhillyBillsService: LegislationDetail #{url} returned #{response.code}")
      return nil
    end

    doc = Nokogiri::HTML(response.body)

    file_number = text(doc, "#ctl00_ContentPlaceHolder1_lblFile2")
    title       = text(doc, "#ctl00_ContentPlaceHolder1_lblTitle2")
    status      = text(doc, "#ctl00_ContentPlaceHolder1_lblStatus2")
    intro_date  = text(doc, "#ctl00_ContentPlaceHolder1_lblIntroDate2")

    return nil if file_number.blank? || title.blank?

    normalize(file_number, title, status, intro_date, url)
  end

  def normalize(file_number, title, status, intro_date, url)
    parsed_date = begin
      Date.parse(intro_date) if intro_date.present?
    rescue ArgumentError
      nil
    end

    {
      source:       "philly_legistar",
      external_id:  file_number,
      identifier:   file_number,
      title:        title,
      status:       status.presence || "In Council",
      status_date:  parsed_date,
      summary:      nil,
      sponsors:     [],
      subjects:     [],
      votes:        [],
      jurisdiction: "philadelphia",
      full_text_url: url
    }
  end

  def text(doc, selector)
    doc.at_css(selector)&.text&.strip
  end
end
