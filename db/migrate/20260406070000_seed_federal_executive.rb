class SeedFederalExecutive < ActiveRecord::Migration[8.1]
  def up
    # ── 47th President of the United States ──
    trump = Person.find_or_initialize_by(slug: 'dtrump-us-president')
    trump.assign_attributes(
      name:               'Donald Trump',
      full_name:          'Donald J. Trump',
      first_name:         'Donald',
      last_name:          'Trump',
      party:              'Republican',
      state:              'US',
      office_type:        'president',
      office_title:       '47th President of the United States',
      term_start:         Date.new(2025, 1, 20),
      term_end:           Date.new(2029, 1, 20),
      website_url:        'https://www.whitehouse.gov',
      contact_url:        'https://www.whitehouse.gov/contact/',
      twitter_handle:     'realDonaldTrump',
      approval_rating:    44,
      approval_source:    'RealClearPolitics avg · Apr 2026',
      bills_signed_count: 68,
      veto_count:         2,
      lt_governor_name:   'JD Vance',
      lt_governor_initials: 'JV',
      divided_government: false,
      divided_gov_note:   'Republicans hold majorities in both the Senate (53–47) and House (220–215). Despite unified government, slim margins mean leadership must manage intraparty factions on every major vote.',
      data_as_of:         'April 2026',
      policy_priorities: [
        { name: 'Israel & Middle East',                  level: 'high',   color: '#1d9e75' },
        { name: 'Iran — maximum pressure campaign',      level: 'high',   color: '#a32d2d' },
        { name: 'Economy, tariffs & jobs',               level: 'high',   color: '#378add' },
        { name: 'Immigration & border enforcement',      level: 'high',   color: '#993556' },
        { name: 'Cuba & Venezuela — sanctions pressure', level: 'medium', color: '#ba7517' },
        { name: 'Energy dominance & deregulation',       level: 'medium', color: '#534ab7' }
      ],
      executive_orders: [
        { number: 'EO 14159', title: 'Declaring a national emergency at the southern border and invoking Title 42 removal authority',                            category: 'Immigration',  date: 'Jan 20, 2025' },
        { number: 'EO 14154', title: 'Unleashing American energy — lifting restrictions on oil, gas, and coal production on federal lands',                       category: 'Energy',       date: 'Jan 20, 2025' },
        { number: 'EO 14158', title: 'Establishing the Department of Government Efficiency (DOGE) to audit and reduce federal spending',                          category: 'Gov. Reform',  date: 'Jan 20, 2025' },
        { number: 'EO 14171', title: 'Restoring maximum pressure on Iran — re-imposing sanctions lifted under Biden and targeting oil exports',                   category: 'Foreign Policy', date: 'Feb 2025'     },
        { number: 'EO 14257', title: 'Imposing reciprocal tariffs on all US trading partners based on their own tariff and non-tariff barriers',                  category: 'Trade',        date: 'Apr 2025'     },
        { number: 'EO 14162', title: 'Withdrawing the United States from the Paris Agreement and reviewing all climate-related federal spending commitments',      category: 'Energy',       date: 'Jan 20, 2025' }
      ],
      budget_total_billions: 7300,
      budget_breakdown: {
        'social security'  => 21,
        'health'           => 26,
        'defense'          => 14,
        'interest on debt' => 14,
        'veterans'         => 5,
        'other'            => 20
      },
      veto_record: nil
    )
    trump.save!
    puts "Seeded: #{trump.full_name} (#{trump.office_title})"

    # ── 50th Vice President of the United States ──
    vance = Person.find_or_initialize_by(slug: 'jvance-us-vp')
    vance.assign_attributes(
      name:               'JD Vance',
      full_name:          'JD Vance',
      first_name:         'JD',
      last_name:          'Vance',
      party:              'Republican',
      state:              'US',
      office_type:        'vp',
      office_title:       '50th Vice President of the United States',
      term_start:         Date.new(2025, 1, 20),
      term_end:           Date.new(2029, 1, 20),
      website_url:        'https://www.whitehouse.gov/administration/jd-vance/',
      contact_url:        'https://www.whitehouse.gov/contact/',
      twitter_handle:     'JDVance',
      approval_rating:    nil,
      approval_source:    nil,
      bills_signed_count: nil,
      veto_count:         nil,
      lt_governor_name:   nil,
      lt_governor_initials: nil,
      divided_government: false,
      divided_gov_note:   'Vance presides over the Senate and casts tie-breaking votes when the chamber is deadlocked. With a 53–47 Republican majority, his vote has been decisive on several early confirmations and budget resolutions.',
      data_as_of:         'April 2026',
      policy_priorities: [
        { name: 'America First foreign policy',            level: 'high',   color: '#1d9e75' },
        { name: 'Industrial policy & manufacturing',       level: 'high',   color: '#378add' },
        { name: 'Border & immigration enforcement',        level: 'high',   color: '#993556' },
        { name: 'Trade protection & tariffs',              level: 'high',   color: '#ba7517' },
        { name: 'Social conservatism & family policy',     level: 'medium', color: '#534ab7' },
        { name: 'NATO skepticism & Europe policy',         level: 'medium', color: '#a32d2d' }
      ],
      executive_orders: nil,
      budget_total_billions: nil,
      budget_breakdown: nil,
      veto_record: nil
    )
    vance.save!
    puts "Seeded: #{vance.full_name} (#{vance.office_title})"
  end

  def down
    Person.where(slug: %w[dtrump-us-president jvance-us-vp]).destroy_all
  end
end
