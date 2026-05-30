class IjdbComment < ApplicationRecord
  self.ignored_columns = [] # explicit — no updated_at column

  belongs_to :ijdb_entry, optional: true  # null = city-level comment

  validates :body, presence: true, length: { maximum: 2000 }
  validates :city, presence: true

  scope :for_city,  ->(city, country = "usa") { where(city: city.to_s.downcase, country: country) }
  scope :city_level, -> { where(ijdb_entry_id: nil) }
  scope :recent,     -> { order(created_at: :desc) }

  def display_author
    author_name.presence || "Anonymous"
  end
end
