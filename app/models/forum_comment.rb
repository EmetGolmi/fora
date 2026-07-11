class ForumComment < ApplicationRecord
  belongs_to :user, optional: true
  validates :bill_num, presence: true
  validates :body, presence: true, length: { minimum: 3, maximum: 1000 }

  scope :for_bill,   ->(num) { where(bill_num: num).order(created_at: :desc) }
  scope :recent,     -> { order(created_at: :desc) }

  def display_handle
    handle.presence || "Anonymous"
  end
end
