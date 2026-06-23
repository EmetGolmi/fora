class CivicRepresentative < ApplicationRecord
  has_many :official_finance_summaries, dependent: :destroy
  has_many :follows, as: :followable, dependent: :destroy

  validates :name, presence: true
end
