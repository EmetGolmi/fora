class NeighborhoodIssue < ApplicationRecord
  has_many :issue_responses,    dependent: :destroy
  has_many :issue_concurrences, dependent: :destroy
  has_many :follows,            as: :followable, dependent: :destroy
  has_many :connections,        as: :source,     dependent: :destroy

  validates :body, presence: true
  validates :rco_slug, presence: true
  validates :perspective_type, inclusion: { in: %w[empathy practical accountability opposition] }
  validates :photo_url, format: {
    with: /\Ahttps?:\/\/.+/i,
    message: "must be a valid URL"
  }, allow_blank: true

  validate :photo_size_reasonable

  THRESHOLD = 10
  PERSPECTIVE_LABELS = {
    'empathy'        => '🤝 With empathy',
    'practical'      => '🔧 Practical fix',
    'accountability' => '📋 Hold accountable',
    'opposition'     => '↔ Different view'
  }.freeze

  def display_author
    anonymous? ? 'Anonymous' : (author_name.presence || 'Anonymous')
  end

  def remaining_concurrences
    [alert_threshold - concurrence_count, 0].max
  end

  def threshold_reached?
    concurrence_count >= alert_threshold
  end

  def progress_percent
    [(concurrence_count.to_f / alert_threshold * 100).round, 100].min
  end

  def share_text_issue
    "#{body.truncate(120)} — neighbors: does this affect you too? Concur on FORA to alert #{rco_slug.upcase} to take action."
  end

  def share_text_recruit
    "#{concurrence_count} of #{alert_threshold} neighbors have Concurred. #{remaining_concurrences} more needed before #{rco_slug.upcase} is alerted. If this affects you, Concur here: [link]"
  end

  def share_text_alerted
    "#{concurrence_count} neighbors Concurred. #{rco_slug.upcase} has been alerted. This issue is now on the official record. [link]"
  end

  def photo_src
    photo_data.presence || photo_url.presence
  end

  def has_photo?
    photo_src.present?
  end

  private

  def photo_size_reasonable
    if photo_data.present? && photo_data.length > 3_000_000
      errors.add(:photo_data, "is too large. Please use a photo under 2MB.")
    end
  end
end
