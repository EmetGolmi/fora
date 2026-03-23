class CivicBill < ApplicationRecord
  validates :source, presence: true
  validates :external_id, presence: true, uniqueness: { scope: :source }
  validates :jurisdiction, presence: true
  validates :title, presence: true

  ACTIVE_STAGES   = %w[introduced committee passed_chamber resolving_differences to_president].freeze
  RESOLVED_STAGES = %w[became_law failed vetoed withdrawn].freeze

  scope :active,   -> { where(bill_stage: ACTIVE_STAGES) }
  scope :resolved, -> { where(bill_stage: RESOLVED_STAGES) }

def self.classify_stage(status_text)
  return "introduced" if status_text.blank?
  t = status_text.downcase

  # OpenStates patterns
  if t.match?(/signed by governor|chaptered|enacted|approved by governor|became law/)
    "became_law"
  elsif t.match?(/vetoed by governor|governor vetoed/)
    "vetoed"
  elsif t.match?(/sent to governor|delivered to governor|presented to governor/)
    "to_president"
  elsif t.match?(/passed (house|senate|chamber)|concurred|third reading passed/)
    "passed_chamber"
  elsif t.match?(/referred to|committed to|re-?referred|in committee|reported/)
    "committee"
  elsif t.match?(/failed|defeated|tabled|postponed indefinitely|withdrawn|died/)
    "failed"

  # Congress.gov patterns (existing)
  elsif t.match?(/became (public |private )?law|signed by the president|enacted|passed over.*veto/)
    "became_law"
  elsif t.match?(/veto/)
    "vetoed"
  elsif t.match?(/presented to the president|sent to the president|to president/)
    "to_president"
  elsif t.match?(/conference committee|resolving differences|ping.pong|held at desk/)
    "resolving_differences"
  elsif t.match?(/passed (the )?(house|senate)|agreed to in (house|senate)|received in the (house|senate)/)
    "passed_chamber"
  elsif t.match?(/referred to (the )?(committee|subcommittee)|ordered to be reported|reported by/)
    "committee"
  elsif t.match?(/failed|rejected|tabled|indefinitely postponed|withdrawn/)
    "failed"
  # City council / Legistar terminal actions
  elsif t.match?(/signed by (the )?mayor|mayor.*sign/)
    "became_law"
  elsif t.match?(/\bpassed\b|\badopted\b/)
    "became_law"
  else
    "introduced"
  end
end
end
