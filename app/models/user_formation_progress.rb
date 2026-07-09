class UserFormationProgress < ApplicationRecord
  belongs_to :user
  belongs_to :formation_track, foreign_key: :track_id
  belongs_to :formation_step,  foreign_key: :step_id
  belongs_to :document, class_name: "LibraryItem", foreign_key: :document_id, optional: true

  enum :status, { not_started: 0, in_progress: 1, done: 2, skipped: 3 }, prefix: true
end
