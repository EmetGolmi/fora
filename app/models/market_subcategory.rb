class MarketSubcategory < ApplicationRecord
  belongs_to :market_domain
  has_many :market_providers, -> { where(is_active: true).order(:name) }, dependent: :destroy
  has_many :market_temple_items, -> { where(is_active: true).order(:position) }, dependent: :destroy
  validates :name, :slug, presence: true
  validates :slug, uniqueness: { scope: :market_domain_id }
end
