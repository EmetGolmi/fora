class CivicBill < ApplicationRecord
  validates :source, presence: true
  validates :external_id, presence: true, uniqueness: { scope: :source }
  validates :jurisdiction, presence: true
  validates :title, presence: true
end
