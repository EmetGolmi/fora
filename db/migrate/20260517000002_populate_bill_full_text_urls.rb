class PopulateBillFullTextUrls < ActiveRecord::Migration[8.1]
  def up
    # PA OpenStates bills (jurisdiction "pennsylvania")
    CivicBill.where(jurisdiction: "pennsylvania").where(full_text_url: [nil, ""]).each do |bill|
      url = pa_url(bill.identifier)
      bill.update_column(:full_text_url, url) if url
    end

    # Federal bills (jurisdiction "federal")
    CivicBill.where(jurisdiction: "federal").where(full_text_url: [nil, ""]).each do |bill|
      url = federal_url(bill.external_id)
      bill.update_column(:full_text_url, url) if url
    end
  end

  def down
    # Cannot reliably reverse — leave URLs in place
  end

  private

  # "HB 2150" → https://www.legis.state.pa.us/cfdocs/billinfo/billinfo.cfm?syear=2023&sind=0&body=H&type=B&bn=2150
  def pa_url(identifier)
    return nil unless identifier =~ /\A([HS])([BR])\s+(\d+)\z/i
    body   = Regexp.last_match(1).upcase  # H or S
    type   = Regexp.last_match(2).upcase  # B or R
    number = Regexp.last_match(3)
    "https://www.legis.state.pa.us/cfdocs/billinfo/billinfo.cfm?syear=2023&sind=0&body=#{body}&type=#{type}&bn=#{number}"
  end

  # "S-3947"    → .../senate-bill/3947
  # "HR-7532"   → .../house-bill/7532
  # "HRES-1071" → .../house-resolution/1071
  # "SRES-..."  → .../senate-resolution/...
  # "HJRES-..." → .../house-joint-resolution/...
  # "SJRES-..." → .../senate-joint-resolution/...
  def federal_url(external_id)
    return nil if external_id.blank?
    base = "https://www.congress.gov/bill/119th-congress"
    case external_id
    when /\AS-(\d+)\z/
      "#{base}/senate-bill/#{Regexp.last_match(1)}"
    when /\AHR-(\d+)\z/
      "#{base}/house-bill/#{Regexp.last_match(1)}"
    when /\AHRES-(\d+)\z/
      "#{base}/house-resolution/#{Regexp.last_match(1)}"
    when /\ASRES-(\d+)\z/
      "#{base}/senate-resolution/#{Regexp.last_match(1)}"
    when /\AHJRES-(\d+)\z/
      "#{base}/house-joint-resolution/#{Regexp.last_match(1)}"
    when /\ASJRES-(\d+)\z/
      "#{base}/senate-joint-resolution/#{Regexp.last_match(1)}"
    when /\AHCONRES-(\d+)\z/
      "#{base}/house-concurrent-resolution/#{Regexp.last_match(1)}"
    end
  end
end
