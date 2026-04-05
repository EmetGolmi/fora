class SeedParkerPerson < ActiveRecord::Migration[8.1]
  def up
    return if Person.exists?(slug: "cparker-philly-mayor")

    Person.create!(
      name:               "Cherelle Parker",
      slug:               "cparker-philly-mayor",
      full_name:          "Cherelle Parker",
      first_name:         "Cherelle",
      last_name:          "Parker",
      office_type:        "mayor",
      office_title:       "Mayor of Philadelphia",
      office_address:     "City Hall · Room 215 · Philadelphia, PA 19107",
      state:              "PA",
      party:              "Democrat",
      term_start:         Date.new(2024, 1, 1),
      term_end:           Date.new(2028, 1, 1),
      photo_url:          "https://upload.wikimedia.org/wikipedia/commons/f/f1/Councilmember_Parker_Hosts_Street_Renaming_to_Honor_Vanita_Cruse_10-29-2021_%2851647482649%29_%28closer_crop%29.jpg",
      website_url:        "https://www.phila.gov/departments/mayor/",
      contact_url:        "https://www.phila.gov/departments/mayor/contact-the-mayors-office/",
      twitter_handle:     "PhillyMayor",
      data_as_of:         "March 2026",
      approval_rating:    63,
      approval_source:    "Pew Charitable Trusts · Jan–Mar 2025",
      budget_total_billions: 6.77,
      budget_breakdown:   {
        "public safety"        => 36,
        "economic opportunity" => 22,
        "housing"              => 18,
        "clean & green"        => 14,
        "education"            => 10
      },
      veto_count:         0,
      bills_signed_count: 300,
      lt_governor_name:   nil,
      lt_governor_initials: nil,
      divided_government: false,
      divided_gov_note:   nil,
      policy_priorities: [
        { "name" => "Public safety & gun violence reduction",  "level" => "high",   "color" => "#993556" },
        { "name" => "Economic opportunity & tax reform",       "level" => "high",   "color" => "#b8860b" },
        { "name" => "Housing affordability (H.O.M.E.)",        "level" => "high",   "color" => "#534ab7" },
        { "name" => "Clean & green neighborhoods",             "level" => "medium", "color" => "#1d9e75" },
        { "name" => "Education & workforce development",       "level" => "medium", "color" => "#378add" }
      ],
      executive_orders: [
        { "number" => "EO 1-24", "title" => "Declaring a public safety emergency and directing a comprehensive police response plan", "category" => "Public Safety", "date" => "Jan 2024" },
        { "number" => "EO 2-24", "title" => "Reforming city government to be more visible, responsive, and effective in service delivery", "category" => "Government Reform", "date" => "Jan 2024" },
        { "number" => "EO 3-24", "title" => "Removing barriers to city employment, including eliminating some four-year degree requirements", "category" => "Economic Opportunity", "date" => "Jan 2024" },
        { "number" => "EO 4-24", "title" => "Vision Zero — directing a traffic safety strategy to eliminate fatal crashes by 2050", "category" => "Transportation", "date" => "Mar 2024" },
        { "number" => "EO 5-24", "title" => "PHL Open for Business — streamlining permitting, licensing and regulatory approvals", "category" => "Economic Opportunity", "date" => "Apr 2024" },
        { "number" => "EO 6-24", "title" => "Establishing the Clean and Green Cabinet to coordinate quality-of-life and cleanup efforts", "category" => "Clean & Green", "date" => "May 2024" }
      ],
      veto_record: []
    )
  end

  def down
    Person.find_by(slug: "cparker-philly-mayor")&.destroy
  end
end
