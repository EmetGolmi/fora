class CivicRepresentative < ApplicationRecord
  has_many :official_finance_summaries, dependent: :destroy

  validates :name, presence: true
end
