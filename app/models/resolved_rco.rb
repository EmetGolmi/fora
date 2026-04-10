class ResolvedRco < ApplicationRecord
  validates :address_key, presence: true, uniqueness: true
end
