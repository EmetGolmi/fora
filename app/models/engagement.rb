class Engagement < ApplicationRecord
  has_many :engagement_participants, dependent: :destroy
  has_many :civic_profiles, through: :engagement_participants
  has_many :library_items, dependent: :nullify

  enum :status, { current: 0, completed: 1 }

  validates :title, presence: true

  before_create :assign_case_number

  private

  def assign_case_number
    return if case_number.present?
    date_prefix = Date.today.strftime("%Y%m%d")
    # find the highest sequence for today and increment
    last = Engagement.where("case_number LIKE ?", "#{date_prefix}-%")
                     .order(:case_number).last
    seq = last ? (last.case_number.split("-").last.to_i + 1) : 1
    self.case_number = "#{date_prefix}-#{seq.to_s.rjust(3, '0')}"
  end
end
