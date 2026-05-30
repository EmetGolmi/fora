class IjdbFoiaRequest < ApplicationRecord
  STATUSES = %w[drafted filed responded appealed].freeze

  STATUS_LABELS = {
    "drafted"    => "Drafted",
    "filed"      => "Filed",
    "responded"  => "Response received",
    "appealed"   => "Appealed",
  }.freeze

  belongs_to :ijdb_entry, optional: true

  validates :body,   presence: true, on: :create,
            if: -> { letter_text.blank? }
  validates :status, inclusion: { in: STATUSES }

  scope :for_city,  ->(city) { where(city: city.to_s.downcase) }
  scope :by_status, -> { order(Arel.sql("CASE status WHEN 'filed' THEN 0 WHEN 'responded' THEN 1 WHEN 'appealed' THEN 2 ELSE 3 END")) }
  scope :filed,     -> { where(status: "filed") }
  scope :open,      -> { where(status: %w[drafted filed appealed]) }

  def status_label
    STATUS_LABELS[status] || status.to_s.humanize
  end
end
