class CivicProfile < ApplicationRecord
  belongs_to :user

  has_many :engagement_participants, dependent: :destroy
  has_many :engagements, through: :engagement_participants
  has_many :provider_capabilities, dependent: :destroy
  has_many :library_items, foreign_key: :owner_profile_id, dependent: :destroy

  # Grow chips: mind | body | meaning | means
  GROW_CHIPS   = %w[mind body meaning means].freeze
  # Care tags: home | car | pets | kids | yard | business
  CARE_TAGS    = %w[home car pets kids yard business].freeze

  validates :user, presence: true
end
