class EngagementParticipant < ApplicationRecord
  belongs_to :engagement
  belongs_to :civic_profile

  validates :role, presence: true
  validates :role, uniqueness: { scope: [ :engagement_id, :civic_profile_id ] }
end
