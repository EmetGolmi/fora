class Connection < ApplicationRecord
  belongs_to :civic_profile
  belongs_to :source,  polymorphic: true
  belongs_to :target,  polymorphic: true, optional: true

  validates :civic_profile, :source, presence: true
  validate  :note_or_target_present

  private

  # A Build must do at least one of: link two things together, or add a note.
  # A connection with neither target nor note is an empty record.
  def note_or_target_present
    return if note.present? || target_id.present?
    errors.add(:base, "must include a note or a connected item")
  end
end
