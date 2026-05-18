class PreBallot < ApplicationRecord
  ELECTION_SLUG = 'pa_primary_20260519'.freeze
  RACES = %w[governor lt_governor us_rep pa_state_rep ballot_q1 ballot_q2].freeze
  MIN_DIVISION_COUNT = 5

  validates :ward,               presence: true
  validates :division,           presence: true
  validates :election_slug,      presence: true
  validates :session_token_hash, presence: true,
            uniqueness: { scope: :election_slug }

  def self.division_count(ward, division)
    where(ward: ward, division: division, election_slug: ELECTION_SLUG).count
  end

  def self.ward_count(ward)
    where(ward: ward, election_slug: ELECTION_SLUG).count
  end

  def self.city_count
    where(election_slug: ELECTION_SLUG).count
  end

  def self.race_breakdown(ward, division, race)
    rows = where(ward: ward, division: division, election_slug: ELECTION_SLUG)
             .where.not(race => [nil, ''])
             .group(race)
             .count
    total = rows.values.sum
    return [] if total.zero?
    rows.map do |candidate, count|
      display = candidate.to_s.start_with?('write-in:') ? 'Write-in' : candidate
      { candidate: display, count: count,
        pct: (count.to_f / total * 100).round(1) }
    end.sort_by { |r| -r[:count] }
  end

  def self.ward_division_breakdown(ward)
    where(ward: ward, election_slug: ELECTION_SLUG)
      .group(:division)
      .count
      .map { |div, count| { division: div, count: count } }
      .sort_by { |r| r[:division].to_i }
  end
end
