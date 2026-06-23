module DashboardHelper
  STAGE_POS = {
    "introduced"            => 1,
    "committee"             => 2,
    "passed_chamber"        => 3,
    "resolving_differences" => 4,
    "to_president"          => 4,
    "became_law"            => 5
  }.freeze

  def stage_segs(bill)
    pos = STAGE_POS[bill.bill_stage] || 1
    (1..5).map do |i|
      if    i < pos  then "done"
      elsif i == pos then "now"
      else ""
      end
    end
  end

  def stage_label(bill)
    bill.status.presence || bill.bill_stage.to_s.humanize
  end

  def initials(name)
    parts = name.to_s.split
    [parts.first&.first, parts.last&.first].compact.join.upcase
  end

  def time_ago_short(time)
    return "" unless time
    diff = Time.current - time
    if    diff < 3_600   then "#{(diff / 60).round}m ago"
    elsif diff < 86_400  then "#{(diff / 3_600).round}h ago"
    elsif diff < 604_800 then "#{(diff / 86_400).round}d ago"
    else time.strftime("%b %d")
    end
  end

  def jur_label(bill)
    j = bill.jurisdiction.to_s
    case j
    when /federal/i                   then "Federal"
    when /pennsylvania/i, /\Apa\z/i  then "PA"
    when /philadelphia/i              then "City"
    else j.split.last(2).join(" ")
    end
  end

  def sponsors_line(bill)
    sp = Array(bill.sponsors).first
    sp ? "sponsored by #{sp['name'] || sp[:name]}" : ""
  end
end
