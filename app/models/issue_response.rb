class IssueResponse < ApplicationRecord
  belongs_to :neighborhood_issue

  validates :body, presence: true
  validates :perspective_type, inclusion: { in: %w[empathy practical accountability opposition] }

  def display_author
    return "#{author_name.presence || 'RCO Committee'}" if official?
    anonymous? ? 'Anonymous' : (author_name.presence || 'Anonymous')
  end
end
