class IssueResponse < ApplicationRecord
  belongs_to :neighborhood_issue

  validates :body, presence: true
  validates :perspective_type, inclusion: { in: %w[empathy practical accountability opposition] }
  validates :photo_url, format: {
    with: /\Ahttps?:\/\/.+/i,
    message: "must be a valid URL"
  }, allow_blank: true

  validate :photo_size_reasonable

  def display_author
    return "#{author_name.presence || 'RCO Committee'}" if official?
    anonymous? ? 'Anonymous' : (author_name.presence || 'Anonymous')
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
