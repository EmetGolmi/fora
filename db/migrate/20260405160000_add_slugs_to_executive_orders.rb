class AddSlugsToExecutiveOrders < ActiveRecord::Migration[8.1]
  SHAPIRO_UPDATES = {
    "EO 2024-09" => { "slug" => "pa-202409", "official_url" => "https://www.governor.pa.gov/executive-orders/" },
    "EO 2024-06" => { "slug" => "pa-202406", "official_url" => "https://www.governor.pa.gov/executive-orders/" },
    "EO 2023-14" => { "slug" => "pa-202314", "official_url" => "https://www.governor.pa.gov/executive-orders/" },
    "EO 2023-02" => { "slug" => "pa-202302", "official_url" => "https://www.governor.pa.gov/executive-orders/" },
  }.freeze

  PARKER_UPDATES = {
    "EO 1-24" => { "slug" => "phl-202401", "official_url" => "https://www.phila.gov/departments/mayor/executive-orders/" },
    "EO 2-24" => { "slug" => "phl-202402", "official_url" => "https://www.phila.gov/departments/mayor/executive-orders/" },
    "EO 3-24" => { "slug" => "phl-202403", "official_url" => "https://www.phila.gov/departments/mayor/executive-orders/" },
    "EO 4-24" => { "slug" => "phl-202404", "official_url" => "https://www.phila.gov/departments/mayor/executive-orders/" },
    "EO 5-24" => { "slug" => "phl-202405", "official_url" => "https://www.phila.gov/departments/mayor/executive-orders/" },
    "EO 6-24" => { "slug" => "phl-202406", "official_url" => "https://www.phila.gov/departments/mayor/executive-orders/" },
  }.freeze

  def up
    [["jshapiro-pa-gov", SHAPIRO_UPDATES], ["cparker-philly-mayor", PARKER_UPDATES]].each do |slug, updates|
      person = Person.find_by(slug: slug)
      next unless person

      updated = (person.executive_orders || []).map do |eo|
        extra = updates[eo["number"]]
        extra ? eo.merge(extra) : eo
      end
      person.update_columns(executive_orders: updated)
    end
  end

  def down
    Person.where(slug: %w[jshapiro-pa-gov cparker-philly-mayor]).each do |person|
      stripped = (person.executive_orders || []).map { |eo| eo.except("slug", "official_url") }
      person.update_columns(executive_orders: stripped)
    end
  end
end
