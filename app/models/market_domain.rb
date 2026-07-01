class MarketDomain < ApplicationRecord
  has_many :market_subcategories, -> { order(:position) }, dependent: :destroy
  has_many :market_temple_items, dependent: :nullify
  validates :name, :slug, :icon, presence: true
  validates :slug, uniqueness: true
end
