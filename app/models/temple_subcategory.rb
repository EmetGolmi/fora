class TempleSubcategory < ApplicationRecord
  belongs_to :temple_domain
  validates :name, :slug, presence: true
  validates :slug, uniqueness: { scope: :temple_domain_id }
end
