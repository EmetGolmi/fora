class IssueConcurrence < ApplicationRecord
  belongs_to :neighborhood_issue
  belongs_to :civic_profile, optional: true  # nil = anonymous (session_token path)

  # Anonymous concurrences still require a session_token.
  # Logged-in concurrences require a civic_profile_id; session_token can be blank.
  validates :session_token, presence: true, if: -> { civic_profile_id.nil? }
  validates :neighborhood_issue_id, uniqueness: { scope: :session_token },
                                    if: -> { session_token.present? }
  # DB partial unique index handles the logged-in uniqueness constraint.

  # Constituency meter: verified residents who concurred on this issue.
  # NEVER reads citizenship or immigration status — only residency_verified.
  scope :verified_resident, -> {
    joins(:civic_profile).where(civic_profiles: { residency_verified: true })
  }
end
