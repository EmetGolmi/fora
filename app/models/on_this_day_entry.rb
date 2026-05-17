class OnThisDayEntry < ApplicationRecord
  validates :month,      presence: true, inclusion: { in: 1..12 }
  validates :day,        presence: true, inclusion: { in: 1..31 }
  validates :entry_type, presence: true, inclusion: { in: %w[event birth death] }
  validates :title,      presence: true
  validates :body,       presence: true
  validates :verified,   inclusion: { in: %w[confirmed review unverified] }

  scope :for_date,   ->(date) { where(month: date.month, day: date.day) }
  scope :for_today,  -> { for_date(Time.current.in_time_zone("America/New_York").to_date) }
  scope :featured,   -> { where(is_featured: true) }
  scope :events,     -> { where(entry_type: "event") }
  scope :births,     -> { where(entry_type: "birth") }
  scope :deaths,     -> { where(entry_type: "death") }
  scope :confirmed,  -> { where(verified: "confirmed") }
end
