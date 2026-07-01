class MarketProvider < ApplicationRecord
  belongs_to :market_subcategory
  enum :provider_type, { business: 0, independent: 1, community: 2, program: 3 }
  validates :name, :provider_type, presence: true
  scope :active, -> { where(is_active: true) }
end
