class FormationStep < ApplicationRecord
  belongs_to :formation_track, foreign_key: :track_id

  enum :requirement, { required: 0, recommended: 1, optional: 2 }, prefix: true
end
