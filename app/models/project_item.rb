class ProjectItem < ApplicationRecord
  belongs_to :project
  belongs_to :itemable, polymorphic: true

  validates :project, :itemable, presence: true
  # Uniqueness enforced by idx_project_items_unique in the DB.
end
