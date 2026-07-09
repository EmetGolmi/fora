class ComplianceObligation < ApplicationRecord
  belongs_to :profile,     class_name: "CivicProfile",  foreign_key: :profile_id
  belongs_to :source_step, class_name: "FormationStep", foreign_key: :source_step_id, optional: true

  enum :obligation_type, { filing: 0, tax: 1, renewal: 2, license: 3, insurance: 4 }, prefix: true
  enum :cadence,         { annual: 0, quarterly: 1, biennial: 2, custom: 3 },          prefix: true
  enum :status,          { upcoming: 0, due: 1, filed: 2, lapsed: 3 },                 prefix: true
end
