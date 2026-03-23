class ResolvedAddress < ApplicationRecord
  validates :address,     presence: true
  validates :job_id,      presence: true
  validates :result_json, presence: true
end
