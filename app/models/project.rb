class Project < ApplicationRecord
  belongs_to :civic_profile
  has_many   :project_items, dependent: :destroy

  validates :title, presence: true
end
