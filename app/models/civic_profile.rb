class CivicProfile < ApplicationRecord
  belongs_to :user

  has_many :engagement_participants, dependent: :destroy
  has_many :engagements, through: :engagement_participants
  has_many :provider_capabilities, dependent: :destroy
  has_many :library_items, foreign_key: :owner_profile_id, dependent: :destroy

  # Dashboard social graph
  has_many :follows,      dependent: :destroy
  has_many :connections,  dependent: :destroy
  has_many :projects,     dependent: :destroy
  has_many :issue_concurrences, dependent: :nullify

  # Convenience: the set of things this profile is following
  has_many :followed_bills,    -> { where(follows: { followable_type: "CivicBill" }) },
           through: :follows, source: :followable, source_type: "CivicBill"
  has_many :followed_issues,   -> { where(follows: { followable_type: "NeighborhoodIssue" }) },
           through: :follows, source: :followable, source_type: "NeighborhoodIssue"
  has_many :followed_reps,     -> { where(follows: { followable_type: "CivicRepresentative" }) },
           through: :follows, source: :followable, source_type: "CivicRepresentative"

  def following?(thing)
    follows.exists?(followable: thing)
  end

  # Grow chips: mind | body | meaning | means
  GROW_CHIPS   = %w[mind body meaning means].freeze
  # Care tags: home | car | pets | kids | yard | business
  CARE_TAGS    = %w[home car pets kids yard business].freeze

  validates :user, presence: true
end
