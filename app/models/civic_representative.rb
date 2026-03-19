class CivicRepresentative < ApplicationRecord
  validates :name, presence: true
end
