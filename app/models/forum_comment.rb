class ForumComment < ApplicationRecord
  belongs_to :user, optional: true

  PERSPECTIVE_TYPES = %w[support oppose side_effect unforeseen error_omission general].freeze

  validates :bill_num,         presence: true
  validates :body,             presence: true, length: { minimum: 3, maximum: 1000 }
  validates :perspective_type, inclusion: { in: PERSPECTIVE_TYPES }

  scope :for_bill,       ->(num) { where(bill_num: num).order(created_at: :desc) }
  scope :by_perspective, ->(t)   { where(perspective_type: t) }
  scope :recent,         ->      { order(created_at: :desc) }

  def display_handle
    handle.presence || "Anonymous"
  end
end
