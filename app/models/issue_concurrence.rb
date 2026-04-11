class IssueConcurrence < ApplicationRecord
  belongs_to :neighborhood_issue
  validates :session_token, presence: true
  validates :neighborhood_issue_id, uniqueness: { scope: :session_token }
end
