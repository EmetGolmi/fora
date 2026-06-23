class Follow < ApplicationRecord
  belongs_to :civic_profile
  belongs_to :followable, polymorphic: true

  validates :civic_profile, :followable, presence: true
  # Uniqueness enforced by idx_follows_unique in the DB.
  # The controller uses find_or_create_by / destroy to toggle (Spark / un-Spark).
end
