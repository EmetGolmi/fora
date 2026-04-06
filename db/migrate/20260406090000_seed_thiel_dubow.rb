class SeedThielDubow < ActiveRecord::Migration[8.1]
  def up
    # ── Adam Thiel — Managing Director ──
    p = Person.find_or_initialize_by(slug: 'athiel-philly-md')
    p.assign_attributes(
      name:         'Adam Thiel',
      full_name:    'Adam Thiel',
      first_name:   'Adam',
      last_name:    'Thiel',
      party:        'Appointed',
      state:        'PA',
      office_type:  'managing_director',
      office_title: 'Managing Director of Philadelphia',
      office_address: 'Municipal Services Building · 1401 JFK Blvd, 14th Fl · Philadelphia, PA 19102',
      website_url:  'https://www.phila.gov/departments/office-of-the-managing-director/',
      contact_url:  'https://www.phila.gov/departments/office-of-the-managing-director/',
      photo_url:    nil,
      twitter_handle: nil,
      term_start:   Date.new(2024, 1, 1),
      term_end:     Date.new(2028, 1, 1),
      data_as_of:   'April 2026',
      veto_count:   nil,
      bills_signed_count: nil,
      approval_rating: nil,
      lt_governor_name: nil,
      divided_gov_note: nil,
      budget_total_billions: nil,
      budget_breakdown: {},
      policy_priorities: [
        { 'name' => 'Public safety & emergency coordination', 'level' => 'high',   'color' => '#993556' },
        { 'name' => 'City service delivery & agency performance', 'level' => 'high',   'color' => '#378add' },
        { 'name' => 'Infrastructure & capital project oversight', 'level' => 'high',   'color' => '#b8860b' },
        { 'name' => 'Interdepartmental coordination & efficiency', 'level' => 'medium', 'color' => '#1d9e75' },
        { 'name' => 'Homelessness & encampment response policy', 'level' => 'medium', 'color' => '#534ab7' }
      ],
      executive_orders: [],
      veto_record: []
    )
    p.save!
    puts "Seeded: #{p.full_name}"

    # ── Rob Dubow — Director of Finance ──
    p = Person.find_or_initialize_by(slug: 'rdubow-philly-finance')
    p.assign_attributes(
      name:         'Rob Dubow',
      full_name:    'Rob Dubow',
      first_name:   'Rob',
      last_name:    'Dubow',
      party:        'Appointed',
      state:        'PA',
      office_type:  'finance_director',
      office_title: 'Director of Finance',
      office_address: 'Municipal Services Building · 1401 JFK Blvd, 6th Fl · Philadelphia, PA 19102',
      website_url:  'https://www.phila.gov/departments/office-of-the-director-of-finance/',
      contact_url:  'https://www.phila.gov/departments/office-of-the-director-of-finance/',
      photo_url:    nil,
      twitter_handle: nil,
      term_start:   Date.new(2024, 1, 1),
      term_end:     Date.new(2028, 1, 1),
      data_as_of:   'April 2026',
      veto_count:   nil,
      bills_signed_count: nil,
      approval_rating: nil,
      lt_governor_name: nil,
      divided_gov_note: nil,
      budget_total_billions: 6.77,
      budget_breakdown: {
        'public safety'        => 36,
        'economic opportunity' => 22,
        'housing'              => 18,
        'clean & green'        => 14,
        'education'            => 10
      },
      policy_priorities: [
        { 'name' => 'Long-term fiscal stability & balanced budgets', 'level' => 'high',   'color' => '#1b3a6b' },
        { 'name' => 'Pension fund management & liability reduction',  'level' => 'high',   'color' => '#b8860b' },
        { 'name' => 'Capital investment & bond financing',            'level' => 'high',   'color' => '#378add' },
        { 'name' => 'Revenue diversification & tax policy',           'level' => 'medium', 'color' => '#1d9e75' },
        { 'name' => 'Financial transparency & audit readiness',       'level' => 'medium', 'color' => '#993556' }
      ],
      executive_orders: [],
      veto_record: []
    )
    p.save!
    puts "Seeded: #{p.full_name}"
  end

  def down
    Person.find_by(slug: 'athiel-philly-md')&.destroy
    Person.find_by(slug: 'rdubow-philly-finance')&.destroy
  end
end
