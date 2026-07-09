class FormationTrack < ApplicationRecord
  has_many :formation_steps, foreign_key: :track_id, dependent: :destroy

  enum :entity_type, { sole_prop: 0, single_member_llc: 1, s_corp: 2, pbc: 3, other: 4 }, prefix: true
  enum :authored_by, { fora: 0, profile: 1, office: 2 },                                   prefix: true
end
