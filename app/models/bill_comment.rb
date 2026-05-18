class BillComment < ApplicationRecord
  belongs_to :civic_bill

  STANCES = %w[support oppose amend undecided].freeze
  PERSPECTIVE_TYPES = %w[
    personal_stake
    community_impact
    fiscal_accountability
    historical_context
    prediction
  ].freeze

  validates :civic_bill_id,    presence: true
  validates :stance,           inclusion: { in: STANCES }
  validates :perspective_type, inclusion: { in: PERSPECTIVE_TYPES }
  validates :body,             presence: true, length: { minimum: 10, maximum: 2000 }
  validates :session_token,    presence: true

  scope :for_bill,       ->(bill_id) { where(civic_bill_id: bill_id) }
  scope :by_stance,      ->(s)       { where(stance: s) }
  scope :most_recent,              -> { order(created_at: :desc) }
  scope :public_visible,           -> { where(anonymous: [true, false]) }

  def display_name
    anonymous? ? "Anonymous" : (occupation.present? ? occupation : "Philadelphia resident")
  end
end
