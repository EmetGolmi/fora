class SacredFireEntry < ApplicationRecord
  validates :site_name, :tab, presence: true
  scope :by_tradition, ->(tab) { where(tab: tab) }
  scope :by_country,   ->(c)   { where(country: c) }
  scope :recent,               -> { order(year_of_incident: :desc) }
end
