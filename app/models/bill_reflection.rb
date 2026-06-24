# BillReflection — private journal entry for a user's engagement with a bill.
#
# PRIVACY INVARIANT (enforced by design, not just policy):
#   - Records are private to the owning civic_profile.
#   - They are NEVER surfaced to other users, NEVER used for targeting, ranking,
#     or profiling, NEVER included in aggregate analytics that could identify
#     individuals, and NEVER inferred from or stored beyond what the user
#     explicitly types.
#   - Read access is for the owner only. No sentiment is derived from these fields.
#   - The tone_intercept check is stateless and per-draft; its result is never
#     stored here or anywhere else.
class BillReflection < ApplicationRecord
  VALID_FEELINGS = %w[angry worried hopeful skeptical conflicted].freeze

  belongs_to :civic_profile
  belongs_to :civic_bill

  validates :civic_profile_id, uniqueness: { scope: :civic_bill_id,
                                             message: "already has a reflection for this bill" }
  validate  :feeling_tags_are_valid

  private

  def feeling_tags_are_valid
    return if Array(feeling_tags).all? { |t| VALID_FEELINGS.include?(t) }
    errors.add(:feeling_tags, "contains unrecognised values")
  end
end
