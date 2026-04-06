class SeedThielExtraData < ActiveRecord::Migration[8.1]
  def up
    p = Person.find_by(slug: 'athiel-philly-md')
    return unless p

    p.update!(
      bills_signed_count: 20,   # ~20 departments overseen (repurposed stat)
      extra_data: {
        'status_alert' => 'Thiel is currently on military leave. Deputy MD Michael Carroll is serving as interim Managing Director.',
        'role_callout' => 'The city\'s chief operating officer. The Managing Director runs Philadelphia\'s day-to-day operations — not elected, appointed by the Mayor. If your street isn\'t plowed, your trash isn\'t picked up, or your neighborhood feels unsafe, this office is where that accountability starts.',
        'stats' => [
          { 'value' => '~20',   'label' => 'Departments overseen' },
          { 'value' => '$316K', 'label' => 'Annual salary' },
          { 'value' => '33 yrs','label' => 'Emergency mgmt experience' }
        ],
        'accountability' => {
          'as_of'  => 'March 2026',
          'source' => 'Philadelphia Inquirer reporting · Feb 2026 · Payroll records obtained via public records request',
          'rows'   => [
            { 'key' => 'Time out of office in 2025',               'value' => '~5 months',           'red' => true },
            { 'key' => 'Salary paid as time off (2025)',            'value' => '~50% of $316,200',    'red' => true },
            { 'key' => 'Outside consulting income (2024)',          'value' => '$305,000+',           'red' => false },
            { 'key' => 'Council members with direct contact',       'value' => 'Minimal — most go to Thurman', 'red' => true },
            { 'key' => 'Military leave disclosed before appointment','value' => 'Not publicly disclosed', 'red' => true }
          ]
        },
        'departments' => [
          { 'name' => 'Philadelphia Fire Department',   'why' => 'Emergency response, fire prevention, EMS',           'tag' => 'Public Safety' },
          { 'name' => 'Streets Department',             'why' => 'Trash pickup, snow removal, road maintenance',       'tag' => 'Infrastructure' },
          { 'name' => 'Philadelphia Water Dept.',       'why' => 'Drinking water, stormwater, sewage',                 'tag' => 'Infrastructure' },
          { 'name' => 'Prisons / Dept. of Corrections', 'why' => 'City jail operations, pre-trial detention',         'tag' => 'Public Safety' },
          { 'name' => 'Office of Emergency Management', 'why' => 'Disaster preparedness, crisis coordination',        'tag' => 'Emergency' },
          { 'name' => 'Dept. of Public Health',         'why' => 'Disease surveillance, clinics, Kensington response','tag' => 'Health' }
        ],
        'staff' => [
          { 'initials' => 'MC', 'name' => 'Michael Carroll',     'title' => 'Deputy MD — Transportation & Infrastructure', 'why' => 'Currently serving as interim Managing Director during Thiel\'s leave', 'badge' => 'acting' },
          { 'initials' => 'BC', 'name' => 'Brian Clinton',       'title' => 'Chief of Staff',                               'why' => 'Day-to-day operations of the MD\'s office',                         'badge' => 'key' },
          { 'initials' => 'TM', 'name' => 'Tara Mohr',           'title' => 'First Deputy Managing Director',               'why' => 'Second in command under Thiel' },
          { 'initials' => 'DM', 'name' => 'Dominick Mireles',    'title' => 'Deputy MD — Community Safety',                 'why' => 'Oversees police, fire, prisons, and emergency management coordination' },
          { 'initials' => 'CY', 'name' => 'Crystal Yates-Gale', 'title' => 'Deputy MD — Health & Human Services',          'why' => 'Oversees public health, behavioral health, and social services' },
          { 'initials' => 'AP', 'name' => 'Aparna Palantino',    'title' => 'Deputy MD — Capital Program Office',           'why' => 'Manages city infrastructure investments and capital projects' },
          { 'initials' => 'AC', 'name' => 'Aubrey C. Powers',    'title' => 'Deputy MD — Community Services',               'why' => 'Parks, recreation, libraries, and neighborhood services' },
          { 'initials' => 'SS', 'name' => 'Stephen St. Vincent', 'title' => 'Deputy MD — Strategic Initiatives',            'why' => 'Special projects and mayoral priority initiatives' },
          { 'initials' => 'DW', 'name' => 'David G. Wilson',     'title' => 'Deputy MD — General Services',                 'why' => 'City facilities, fleet, and procurement' },
          { 'initials' => 'SG', 'name' => 'Sharon Gallagher',    'title' => 'Senior Director of Communications',            'why' => 'Press inquiries for the MD\'s office go through her', 'badge' => 'media' }
        ],
        'career_timeline' => [
          { 'title' => 'Managing Director',           'sub' => 'Jan 2024 – present',      'state' => 'active' },
          { 'title' => 'Army Reserve — joined',       'sub' => 'Aug 2024 · Major, 38G',   'state' => 'flag' },
          { 'title' => 'Fire Commissioner + Deputy MD','sub' => '2016 – 2024',            'state' => 'past' },
          { 'title' => 'OEM Director',                'sub' => '2019 – 2022 (concurrent)','state' => 'past' },
          { 'title' => 'VA Deputy Sec. Public Safety', 'sub' => 'Before 2016',            'state' => 'past' }
        ],
        'compensation' => [
          { 'key' => 'City salary',                'value' => '$316,200' },
          { 'key' => 'Consulting income (2024)',   'value' => '$305,000+' },
          { 'key' => 'Lecturing (George Mason)',   'value' => '$7,000' },
          { 'key' => 'Total disclosed (2024)',     'value' => '$628,200+' }
        ]
      }
    )
    puts "Updated Thiel extra_data"
  end

  def down
    Person.find_by(slug: 'athiel-philly-md')&.update!(extra_data: {}, bills_signed_count: nil)
  end
end
