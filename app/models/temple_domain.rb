class TempleDomain < ApplicationRecord
  has_many :temple_subcategories, -> { order(:position) }, dependent: :destroy
  validates :name, :slug, :icon, presence: true
  validates :slug, uniqueness: true
end
