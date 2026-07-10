class ForumDomain < ApplicationRecord
  has_many :forum_subcategories, -> { order(:position) }, dependent: :destroy
  validates :name, :slug, :icon, presence: true
  validates :slug, uniqueness: true
end
