class ForumSubcategory < ApplicationRecord
  belongs_to :forum_domain
  validates :name, :slug, presence: true
  validates :slug, uniqueness: { scope: :forum_domain_id }
end
