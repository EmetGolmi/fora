class OfficialFinanceSummary < ApplicationRecord
  belongs_to :civic_representative

  def pac_pct
    return nil unless total_raised_cents&.positive?
    ((pac_contrib_cents.to_f / total_raised_cents) * 100).round(1)
  end

  def individual_pct
    return nil unless total_raised_cents&.positive?
    ((individual_contrib_cents.to_f / total_raised_cents) * 100).round(1)
  end

  def self_fund_pct
    return nil unless total_raised_cents&.positive?
    ((candidate_self_fund_cents.to_f / total_raised_cents) * 100).round(1)
  end
end
