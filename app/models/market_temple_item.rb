class MarketTempleItem < ApplicationRecord
  belongs_to :market_subcategory, optional: true
  belongs_to :market_domain, optional: true
  enum :item_type, { guide: 0, community: 1, rights: 2 }
  validates :title, presence: true
  scope :active, -> { where(is_active: true).order(:position) }
end
