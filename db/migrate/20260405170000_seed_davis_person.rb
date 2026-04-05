class SeedDavisPerson < ActiveRecord::Migration[8.1]
  def up
    return if Person.exists?(slug: "adavis-pa-ltgov")

    Person.create!(
      name:               "Austin Davis",
      slug:               "adavis-pa-ltgov",
      full_name:          "Austin Davis",
      first_name:         "Austin",
      last_name:          "Davis",
      office_type:        "lt_governor",
      office_title:       "Lieutenant Governor of Pennsylvania",
      state:              "PA",
      party:              "Democrat",
      term_start:         Date.new(2023, 1, 17),
      term_end:           Date.new(2027, 1, 19),
      office_address:     "Main Capitol Building · Harrisburg, PA 17120",
      photo_url:          "https://www.ltgov.pa.gov/wp-content/uploads/sites/175/2023/01/Davis-Official-Headshot.jpg",
      website_url:        "https://www.ltgov.pa.gov",
      contact_url:        "https://www.ltgov.pa.gov/contact",
      twitter_handle:     "LtGovAustinDavis",
      data_as_of:         "March 2026",
      divided_government: true,
      divided_gov_note:   "Davis presides over a Republican-controlled Pennsylvania Senate as its constitutional President — a role that requires building coalitions while advancing the Shapiro-Davis administration's agenda.",
      policy_priorities: [
        { "name" => "Mental health & crisis intervention",    "level" => "high",   "color" => "#378add" },
        { "name" => "Veterans' services & support",           "level" => "high",   "color" => "#1d9e75" },
        { "name" => "Economic opportunity & workforce dev",   "level" => "medium", "color" => "#b8860b" },
        { "name" => "Environmental justice",                  "level" => "medium", "color" => "#2d8a5e" },
        { "name" => "Civic engagement & voting access",       "level" => "medium", "color" => "#534ab7" }
      ]
    )
  end

  def down
    Person.find_by(slug: "adavis-pa-ltgov")&.destroy
  end
end
