class ProviderCapability < ApplicationRecord
  belongs_to :civic_profile

  enum :status, { active: 0, inactive: 1 }

  validates :profession, presence: true
  validates :profession, uniqueness: { scope: :civic_profile_id }
end
