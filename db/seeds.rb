# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# ── Shapiro veto bills ────────────────────────────────────────────────────────
hb1190 = CivicBill.find_or_initialize_by(source: 'pa_legislature', external_id: 'pa-2023-hb1190')
hb1190.assign_attributes(
  jurisdiction: 'PA', identifier: 'HB 1190',
  title:        'An Act amending Title 18 (Crimes and Offenses) of the Pennsylvania Consolidated Statutes, in firearms and other dangerous articles, further providing for persons not to possess, use, manufacture, control, sell or transfer firearms.',
  status:       'Vetoed', status_date: Date.new(2023, 7, 3),
  bill_stage:   'Vetoed',
  full_text_url: 'https://www.legis.state.pa.us/cfdocs/billinfo/billinfo.cfm?syear=2023&sind=0&body=H&type=B&bn=1190'
)
hb1190.save!

sb292 = CivicBill.find_or_initialize_by(source: 'pa_legislature', external_id: 'pa-2023-sb292')
sb292.assign_attributes(
  jurisdiction: 'PA', identifier: 'SB 292',
  title:        'An Act amending the act of June 3, 1937 (P.L.1333, No.320), known as the Pennsylvania Election Code, providing for photo identification requirements for voting.',
  status:       'Vetoed', status_date: Date.new(2024, 6, 28),
  bill_stage:   'Vetoed',
  full_text_url: 'https://www.legis.state.pa.us/cfdocs/billinfo/billinfo.cfm?syear=2023&sind=0&body=S&type=B&bn=292'
)
sb292.save!

sb1 = CivicBill.find_or_initialize_by(source: 'pa_legislature', external_id: 'pa-2023-sb1')
sb1.assign_attributes(
  jurisdiction: 'PA', identifier: 'SB 1',
  title:        'An Act providing for the Pennsylvania Award for Student Success (PASS) program; establishing the PASS Account and providing for its use; and imposing duties on the Department of Education.',
  status:       'Vetoed', status_date: Date.new(2023, 6, 30),
  bill_stage:   'Vetoed',
  full_text_url: 'https://www.legis.state.pa.us/cfdocs/billinfo/billinfo.cfm?syear=2023&sind=0&body=S&type=B&bn=1'
)
sb1.save!
puts "Seeded: Shapiro veto bills (HB 1190, SB 292, SB 1)"

# ── PA Governor: Josh Shapiro ────────────────────────────────────────────────
shapiro = Person.find_or_initialize_by(slug: 'jshapiro-pa-gov')
shapiro.assign_attributes(
  full_name:          'Josh Shapiro',
  first_name:         'Josh',
  last_name:          'Shapiro',
  name:               'Josh Shapiro',
  party:              'Democrat',
  state:              'PA',
  photo_url:          'https://www.governor.pa.gov/wp-content/uploads/2023/01/Shapiro-Official-Portrait.jpg',
  office_type:        'governor',
  office_title:       'Governor of Pennsylvania',
  term_start:         Date.new(2023, 1, 17),
  term_end:           Date.new(2027, 1, 19),
  website_url:        'https://www.governor.pa.gov',
  contact_url:        'https://www.governor.pa.gov/contact',
  twitter_handle:     'GovernorShapiro',
  approval_rating:    52,
  approval_source:    'Franklin & Marshall · Feb 2026',
  budget_total_billions: 48.3,
  budget_breakdown: { education: 35, health: 18, 'human services': 12, transportation: 18, safety: 10, other: 7 },
  veto_count:         9,
  bills_signed_count: 312,
  lt_governor_name:   'Austin Davis',
  lt_governor_initials: 'AD',
  divided_government: true,
  divided_gov_note:   'Pennsylvania has a divided government — Republican-controlled General Assembly. Bills Shapiro signs often reflect negotiated compromise.',
  policy_priorities: [
    { name: 'Education funding & school safety',      level: 'high',   color: '#378add' },
    { name: 'Economic development & permitting reform', level: 'high', color: '#1d9e75' },
    { name: 'Energy transition & environment',         level: 'medium', color: '#ba7517' },
    { name: 'Public safety & criminal justice',        level: 'medium', color: '#993556' },
    { name: 'Housing & infrastructure',                level: 'medium', color: '#534ab7' }
  ],
  executive_orders: [
    { number: 'EO 2024-09', title: 'Establishing the PA Office of Economic Opportunity to streamline business permitting',    category: 'Commerce',    date: 'Oct 2024' },
    { number: 'EO 2024-06', title: 'Directing state agencies to adopt AI use policies protecting workers and student data',   category: 'Technology',  date: 'Jun 2024' },
    { number: 'EO 2023-14', title: 'Joining the Regional Greenhouse Gas Initiative (RGGI) pending final rulemaking',          category: 'Environment', date: 'Nov 2023' },
    { number: 'EO 2023-02', title: 'Reinstating protections against discrimination in state employment for LGBTQ+ workers',   category: 'Civil Rights', date: 'Jan 2023' }
  ],
  veto_record: [
    { bill: 'HB 1190', title: 'Constitutional carry',    note: 'Permitless concealed carry — vetoed Jul 2023',                         outcome: 'vetoed', bill_id: hb1190.id },
    { bill: 'SB 292',  title: 'Voter ID expansion',      note: 'Expanded photo ID requirements — vetoed Jun 2024',                     outcome: 'vetoed', bill_id: sb292.id  },
    { bill: 'SB 1',    title: 'School choice vouchers',  note: 'PASS voucher program — vetoed Jun 2023 · Override attempt failed',      outcome: 'vetoed', bill_id: sb1.id    }
  ],
  data_as_of: 'March 2026'
)
shapiro.save!
puts "Seeded: #{shapiro.full_name} (#{shapiro.office_title})"

# ── Pennsylvania Attorney General ──
sunday = Person.find_or_initialize_by(slug: 'dsunday-pa-ag')
sunday.assign_attributes(
  name:                'Dave Sunday',
  full_name:           'Dave Sunday',
  first_name:          'Dave',
  last_name:           'Sunday',
  party:               'Republican',
  state:               'PA',
  office_type:         'attorney_general',
  office_title:        'Attorney General of Pennsylvania',
  term_start:          Date.new(2025, 1, 21),
  term_end:            Date.new(2029, 1, 1),
  website_url:         'https://www.attorneygeneral.gov',
  contact_url:         'https://www.attorneygeneral.gov/contact/',
  twitter_handle:      'PAAttorneyGen',
  approval_rating:     nil,
  approval_source:     nil,
  data_as_of:          'March 2026',
  divided_government:  true,
  divided_gov_note:    'Sunday is a Republican AG operating alongside a Democratic governor. His office sets enforcement priorities independently of the Shapiro administration.',
  policy_priorities: [
    { name: 'Fentanyl & opioid prosecution',    level: 'high',   color: '#a32d2d' },
    { name: 'Consumer protection & fraud',       level: 'high',   color: '#378add' },
    { name: 'Human trafficking enforcement',     level: 'high',   color: '#993556' },
    { name: 'Election integrity investigations', level: 'medium', color: '#ba7517' },
    { name: 'Antitrust & corporate accountability', level: 'medium', color: '#534ab7' }
  ],
  executive_orders: nil,
  veto_record:      nil,
  veto_count:       nil,
  bills_signed_count: nil,
  lt_governor_name:   nil,
  lt_governor_initials: nil,
  budget_total_billions: 0.15,
  budget_breakdown: { criminal_prosecution: 42, civil_litigation: 28, consumer_protection: 18, administration: 12 }
)
sunday.save!
puts "Seeded: #{sunday.full_name}"

# ── Philadelphia City Council — District 2 ──
johnson = Person.find_or_initialize_by(slug: 'kjohnson-phl-d2')
johnson.assign_attributes(
  name:                         'Kenyatta Johnson',
  full_name:                    'Kenyatta Johnson',
  first_name:                   'Kenyatta',
  last_name:                    'Johnson',
  party:                        'Democrat',
  state:                        'PA',
  office_type:                  'city_council',
  office_title:                 'Philadelphia City Councilmember, District 2',
  district_number:              2,
  district_name:                'South Philadelphia',
  district_neighborhoods:       ['Point Breeze', 'Grays Ferry', 'East Passyunk', 'Pennsport', 'Graduate Hospital', 'Newbold', 'Whitman', 'Lower Moyamensing'],
  district_population:          163_000,
  district_neighborhoods_count: 14,
  district_median_income:       38_200,
  district_owner_occupancy_pct: 43,
  district_rco_count:           12,
  office_phone:                 '(215) 686-3412',
  office_address:               '1501 S Broad St, Philadelphia, PA 19147',
  office_hours:                 'Tue & Thu 10am–4pm',
  website_url:                  'https://phlcouncil.com/kenyatta-johnson/',
  contact_url:                  'https://phlcouncil.com/kenyatta-johnson/contact/',
  photo_url:                    'https://phlcouncil.com/wp-content/uploads/2025/04/CP_Johnson_Close__RED_TIE__up1-e1744149308872.jpg',
  twitter_handle:               'KenyattaJohnson',
  term_start:                   Date.new(2012, 1, 1),
  term_end:                     Date.new(2028, 1, 1),
  attendance_rate_pct:          94,
  bills_introduced_count:       31,
  bills_passed_count:           18,
  party_line_vote_pct:          87,
  data_as_of:                   'March 2026',
  committees: [
    { name: 'Housing, Neighborhood Development & the Homeless', role: 'chair' },
    { name: 'Streets & Services',                               role: 'member' },
    { name: 'Licenses & Inspections',                          role: 'member' },
    { name: 'Budget & Finance',                                role: 'member' }
  ],
  issue_focus_areas: [
    { name: 'Affordable housing',   bills_count: 11, pct: 90, color: '#378add' },
    { name: 'Zoning & development', bills_count: 8,  pct: 72, color: '#ba7517' },
    { name: 'Public safety',        bills_count: 6,  pct: 58, color: '#993556' },
    { name: 'Streets & transit',    bills_count: 4,  pct: 42, color: '#1d9e75' }
  ],
  recent_votes: [
    { vote: 'yes',     bill: 'Bill 240312', title: 'Affordable Housing Preservation Fund — $25M allocation',       result: 'Passed 14–2', date: 'Mar 2024', tag: 'Housing' },
    { vote: 'no',      bill: 'Bill 230891', title: 'Broadway Market zoning variance (1400 S Broad)',               result: 'Failed 8–9',  date: 'Dec 2023', tag: 'Zoning' },
    { vote: 'yes',     bill: 'Bill 240088', title: 'Vision Zero — protected bike lane expansion on Passyunk Ave',  result: 'Passed 11–5', date: 'Feb 2024', tag: 'Streets' },
    { vote: 'abstain', bill: 'Bill 230750', title: 'Police contract ratification — FY 2024 collective bargaining', result: 'Passed 13–1', date: 'Nov 2023', tag: 'Public Safety' },
    { vote: 'yes',     bill: 'Bill 240201', title: 'Short-term rental density cap — owner-occupied exemption',     result: 'Passed 12–4', date: 'Jan 2024', tag: 'Housing' }
  ],
  upcoming_events: [
    { month: 'Apr', day: 10, title: 'City Council session',      location: 'City Hall · Room 400 · 10am',    tag: 'Public welcome', tag_color: 'green' },
    { month: 'Apr', day: 15, title: 'District office hours',     location: '1501 S Broad St · 10am–4pm',     tag: 'Walk-ins ok',    tag_color: 'blue'  },
    { month: 'Apr', day: 22, title: 'Housing Committee hearing', location: '1400 S Broad zoning variance',   tag: 'Testimony open', tag_color: 'amber' }
  ]
)
johnson.save!
puts "Seeded: #{johnson.full_name} (#{johnson.office_title})"

# ── Philadelphia City Council — District 1 ──
squilla = Person.find_or_initialize_by(slug: 'msquilla-phl-d1')
squilla.assign_attributes(
  name:                         'Mark Squilla',
  full_name:                    'Mark Squilla',
  first_name:                   'Mark',
  last_name:                    'Squilla',
  party:                        'Democrat',
  state:                        'PA',
  office_type:                  'city_council',
  office_title:                 'Philadelphia City Councilmember, District 1',
  district_number:              1,
  district_name:                'Northeast Philadelphia / Riverfront',
  district_neighborhoods:       ['Old City', 'Society Hill', 'Fishtown', 'Northern Liberties', 'Port Richmond', 'Bridesburg', 'Kensington'],
  district_population:          161_000,
  district_neighborhoods_count: 12,
  district_median_income:       42_000,
  district_owner_occupancy_pct: 38,
  district_rco_count:           14,
  office_phone:                 '(215) 686-3458',
  office_address:               'Room 580, City Hall, Philadelphia, PA 19107',
  office_hours:                 'Mon–Fri 9am–5pm',
  website_url:                  'https://phlcouncil.com/mark-squilla/',
  contact_url:                  'https://phlcouncil.com/mark-squilla/contact/',
  photo_url:                    'https://phlcouncil.com/wp-content/uploads/2020/02/Councilmember-Mark-Squilla.jpg',
  twitter_handle:               'MarkSquilla',
  term_start:                   Date.new(2012, 1, 1),
  term_end:                     Date.new(2028, 1, 1),
  attendance_rate_pct:          91,
  bills_introduced_count:       28,
  bills_passed_count:           16,
  party_line_vote_pct:          85,
  data_as_of:                   'March 2026',
  committees: [
    { name: 'Commerce & Economic Development',          role: 'chair'  },
    { name: 'Licenses & Inspections',                   role: 'member' },
    { name: 'Streets & Services',                       role: 'member' }
  ]
)
squilla.save!
puts "Seeded: #{squilla.full_name} (#{squilla.office_title})"

# ── Philadelphia City Council — District 3 ──
gauthier = Person.find_or_initialize_by(slug: 'jgauthier-phl-d3')
gauthier.assign_attributes(
  name:                         'Jamie Gauthier',
  full_name:                    'Jamie Gauthier',
  first_name:                   'Jamie',
  last_name:                    'Gauthier',
  party:                        'Democrat',
  state:                        'PA',
  office_type:                  'city_council',
  office_title:                 'Philadelphia City Councilmember, District 3',
  district_number:              3,
  district_name:                'West Philadelphia',
  district_neighborhoods:       ['Cobbs Creek', 'Kingsessing', 'Woodland Terrace', 'Spruce Hill', 'Cedar Park', 'Squirrel Hill', 'Elmwood', 'Paschall'],
  district_population:          162_000,
  district_neighborhoods_count: 10,
  district_median_income:       34_500,
  district_owner_occupancy_pct: 40,
  district_rco_count:           11,
  office_phone:                 '(215) 686-3448',
  office_address:               'Room 580, City Hall, Philadelphia, PA 19107',
  office_hours:                 'Mon–Fri 9am–5pm',
  website_url:                  'https://phlcouncil.com/jamie-gauthier/',
  contact_url:                  'https://phlcouncil.com/jamie-gauthier/contact/',
  photo_url:                    'https://phlcouncil.com/wp-content/uploads/2020/02/Councilmember-Jamie-Gauthier.jpg',
  twitter_handle:               'JamieGauthier3',
  term_start:                   Date.new(2020, 1, 1),
  term_end:                     Date.new(2028, 1, 1),
  attendance_rate_pct:          93,
  bills_introduced_count:       24,
  bills_passed_count:           13,
  party_line_vote_pct:          89,
  data_as_of:                   'March 2026',
  committees: [
    { name: 'Housing, Neighborhood Development & the Homeless', role: 'member' },
    { name: 'Public Health & Human Services',                   role: 'member' },
    { name: 'Finance',                                          role: 'member' }
  ]
)
gauthier.save!
puts "Seeded: #{gauthier.full_name} (#{gauthier.office_title})"

# ── Philadelphia City Council — District 4 ──
cjones = Person.find_or_initialize_by(slug: 'cjones-phl-d4')
cjones.assign_attributes(
  name:                         'Curtis Jones Jr.',
  full_name:                    'Curtis Jones Jr.',
  first_name:                   'Curtis',
  last_name:                    'Jones',
  party:                        'Democrat',
  state:                        'PA',
  office_type:                  'city_council',
  office_title:                 'Philadelphia City Councilmember, District 4',
  district_number:              4,
  district_name:                'Southwest Philadelphia',
  district_neighborhoods:       ['Overbrook', 'Wynnefield', 'Carroll Park', 'Haddington', 'Mill Creek', 'Mantua', 'Belmont', 'Parkside'],
  district_population:          158_000,
  district_neighborhoods_count: 10,
  district_median_income:       31_000,
  district_owner_occupancy_pct: 45,
  district_rco_count:           9,
  office_phone:                 '(215) 686-3404',
  office_address:               'Room 580, City Hall, Philadelphia, PA 19107',
  office_hours:                 'Mon–Fri 9am–5pm',
  website_url:                  'https://phlcouncil.com/curtis-jones-jr/',
  contact_url:                  'https://phlcouncil.com/curtis-jones-jr/contact/',
  photo_url:                    'https://phlcouncil.com/wp-content/uploads/2020/02/Councilmember-Curtis-Jones-Jr.jpg',
  twitter_handle:               'CurtisJonesJr',
  term_start:                   Date.new(2008, 1, 1),
  term_end:                     Date.new(2028, 1, 1),
  attendance_rate_pct:          88,
  bills_introduced_count:       22,
  bills_passed_count:           14,
  party_line_vote_pct:          83,
  data_as_of:                   'March 2026',
  committees: [
    { name: 'Transportation & Public Utilities',  role: 'chair'  },
    { name: 'Streets & Services',                 role: 'member' },
    { name: 'Public Safety',                      role: 'member' }
  ]
)
cjones.save!
puts "Seeded: #{cjones.full_name} (#{cjones.office_title})"

# ── Philadelphia City Council — District 5 ──
jyoung = Person.find_or_initialize_by(slug: 'jyoung-phl-d5')
jyoung.assign_attributes(
  name:                         'Jeffery Young Jr.',
  full_name:                    'Jeffery Young Jr.',
  first_name:                   'Jeffery',
  last_name:                    'Young',
  party:                        'Democrat',
  state:                        'PA',
  office_type:                  'city_council',
  office_title:                 'Philadelphia City Councilmember, District 5',
  district_number:              5,
  district_name:                'North Philadelphia',
  district_neighborhoods:       ['Olney', 'Logan', 'Fern Rock', 'Oak Lane', 'Cheltenham Ave corridor', 'Germantown Ave North', 'Crescentville'],
  district_population:          157_000,
  district_neighborhoods_count: 9,
  district_median_income:       30_000,
  district_owner_occupancy_pct: 44,
  district_rco_count:           8,
  office_phone:                 '(215) 686-3406',
  office_address:               'Room 580, City Hall, Philadelphia, PA 19107',
  office_hours:                 'Mon–Fri 9am–5pm',
  website_url:                  'https://phlcouncil.com/jeffery-young-jr/',
  contact_url:                  'https://phlcouncil.com/jeffery-young-jr/contact/',
  photo_url:                    'https://phlcouncil.com/wp-content/uploads/2024/11/CM-Young.jpg',
  twitter_handle:               nil,
  term_start:                   Date.new(2024, 1, 1),
  term_end:                     Date.new(2028, 1, 1),
  attendance_rate_pct:          90,
  bills_introduced_count:       8,
  bills_passed_count:           3,
  party_line_vote_pct:          88,
  data_as_of:                   'March 2026',
  committees: [
    { name: 'Public Safety',                                    role: 'member' },
    { name: 'Housing, Neighborhood Development & the Homeless', role: 'member' },
    { name: 'Labor & Civil Service',                            role: 'member' }
  ]
)
jyoung.save!
puts "Seeded: #{jyoung.full_name} (#{jyoung.office_title})"

# ── Philadelphia City Council — District 6 ──
driscoll = Person.find_or_initialize_by(slug: 'mdriscoll-phl-d6')
driscoll.assign_attributes(
  name:                         'Mike Driscoll',
  full_name:                    'Michael Driscoll',
  first_name:                   'Mike',
  last_name:                    'Driscoll',
  party:                        'Democrat',
  state:                        'PA',
  office_type:                  'city_council',
  office_title:                 'Philadelphia City Councilmember, District 6',
  district_number:              6,
  district_name:                'Northeast Philadelphia',
  district_neighborhoods:       ['Mayfair', 'Holmesburg', 'Torresdale', 'Tacony', 'Wissinoming', 'Frankford', 'Millbrook'],
  district_population:          160_000,
  district_neighborhoods_count: 11,
  district_median_income:       52_000,
  district_owner_occupancy_pct: 65,
  district_rco_count:           10,
  office_phone:                 '(215) 686-3408',
  office_address:               'Room 580, City Hall, Philadelphia, PA 19107',
  office_hours:                 'Mon–Fri 9am–5pm',
  website_url:                  'https://phlcouncil.com/mike-driscoll/',
  contact_url:                  'https://phlcouncil.com/mike-driscoll/contact/',
  photo_url:                    'https://phlcouncil.com/wp-content/uploads/2022/06/Councilmember-Mike-Driscoll.jpg',
  twitter_handle:               'MikeDriscoll6',
  term_start:                   Date.new(2022, 1, 1),
  term_end:                     Date.new(2028, 1, 1),
  attendance_rate_pct:          92,
  bills_introduced_count:       18,
  bills_passed_count:           10,
  party_line_vote_pct:          86,
  data_as_of:                   'March 2026',
  committees: [
    { name: 'Streets & Services',             role: 'chair'  },
    { name: 'Licenses & Inspections',         role: 'member' },
    { name: 'Commerce & Economic Development', role: 'member' }
  ]
)
driscoll.save!
puts "Seeded: #{driscoll.full_name} (#{driscoll.office_title})"

# ── Philadelphia City Council — District 7 ──
lozada = Person.find_or_initialize_by(slug: 'qlozada-phl-d7')
lozada.assign_attributes(
  name:                         'Quetcy Lozada',
  full_name:                    'Quetcy Lozada',
  first_name:                   'Quetcy',
  last_name:                    'Lozada',
  party:                        'Democrat',
  state:                        'PA',
  office_type:                  'city_council',
  office_title:                 'Philadelphia City Councilmember, District 7',
  district_number:              7,
  district_name:                'North Philadelphia / Hunting Park',
  district_neighborhoods:       ['Fairhill', 'Hunting Park', 'Tioga', 'Juniata', 'Norris Square', 'Kensington North', 'Hartranft', 'Glenwood'],
  district_population:          156_000,
  district_neighborhoods_count: 10,
  district_median_income:       26_000,
  district_owner_occupancy_pct: 32,
  district_rco_count:           9,
  office_phone:                 '(215) 686-3410',
  office_address:               'Room 580, City Hall, Philadelphia, PA 19107',
  office_hours:                 'Mon–Fri 9am–5pm',
  website_url:                  'https://phlcouncil.com/quetcy-lozada/',
  contact_url:                  'https://phlcouncil.com/quetcy-lozada/contact/',
  photo_url:                    'https://phlcouncil.com/wp-content/uploads/2022/12/Councilmember-Quetcy-Lozada.jpg',
  twitter_handle:               'QuetcyLozada',
  term_start:                   Date.new(2022, 1, 1),
  term_end:                     Date.new(2028, 1, 1),
  attendance_rate_pct:          92,
  bills_introduced_count:       19,
  bills_passed_count:           11,
  party_line_vote_pct:          88,
  data_as_of:                   'March 2026',
  committees: [
    { name: 'Public Health & Human Services',                   role: 'chair'  },
    { name: 'Housing, Neighborhood Development & the Homeless', role: 'member' },
    { name: 'Labor & Civil Service',                            role: 'member' }
  ]
)
lozada.save!
puts "Seeded: #{lozada.full_name} (#{lozada.office_title})"

# ── Philadelphia City Council — District 8 ──
bass = Person.find_or_initialize_by(slug: 'cbass-phl-d8')
bass.assign_attributes(
  name:                         'Cindy Bass',
  full_name:                    'Cindy Bass',
  first_name:                   'Cindy',
  last_name:                    'Bass',
  party:                        'Democrat',
  state:                        'PA',
  office_type:                  'city_council',
  office_title:                 'Philadelphia City Councilmember, District 8',
  district_number:              8,
  district_name:                'Northwest Philadelphia',
  district_neighborhoods:       ['Mt. Airy', 'Germantown', 'Chestnut Hill', 'West Mt. Airy', 'East Mt. Airy', 'Wyndmoor border'],
  district_population:          157_000,
  district_neighborhoods_count: 8,
  district_median_income:       48_000,
  district_owner_occupancy_pct: 52,
  district_rco_count:           10,
  office_phone:                 '(215) 686-3414',
  office_address:               'Room 580, City Hall, Philadelphia, PA 19107',
  office_hours:                 'Mon–Fri 9am–5pm',
  website_url:                  'https://phlcouncil.com/cindy-bass/',
  contact_url:                  'https://phlcouncil.com/cindy-bass/contact/',
  photo_url:                    'https://phlcouncil.com/wp-content/uploads/2020/02/Cindy-Bass-headshot-Mar25.jpg',
  twitter_handle:               'CindyBassD8',
  term_start:                   Date.new(2012, 1, 1),
  term_end:                     Date.new(2028, 1, 1),
  attendance_rate_pct:          87,
  bills_introduced_count:       26,
  bills_passed_count:           15,
  party_line_vote_pct:          84,
  data_as_of:                   'March 2026',
  committees: [
    { name: 'Parks, Recreation & Cultural Affairs', role: 'chair'  },
    { name: 'Public Health & Human Services',       role: 'member' },
    { name: 'Finance',                              role: 'member' }
  ]
)
bass.save!
puts "Seeded: #{bass.full_name} (#{bass.office_title})"

# ── Philadelphia City Council — District 9 ──
phillips = Person.find_or_initialize_by(slug: 'aphillips-phl-d9')
phillips.assign_attributes(
  name:                         'Anthony Phillips',
  full_name:                    'Anthony Phillips',
  first_name:                   'Anthony',
  last_name:                    'Phillips',
  party:                        'Democrat',
  state:                        'PA',
  office_type:                  'city_council',
  office_title:                 'Philadelphia City Councilmember, District 9',
  district_number:              9,
  district_name:                'North Philadelphia / Logan',
  district_neighborhoods:       ['Logan', 'Feltonville', 'Fern Rock', 'Ogontz', 'West Oak Lane', 'East Oak Lane', 'Lawndale'],
  district_population:          158_000,
  district_neighborhoods_count: 9,
  district_median_income:       33_000,
  district_owner_occupancy_pct: 47,
  district_rco_count:           8,
  office_phone:                 '(215) 686-3416',
  office_address:               'Room 580, City Hall, Philadelphia, PA 19107',
  office_hours:                 'Mon–Fri 9am–5pm',
  website_url:                  'https://phlcouncil.com/anthony-phillips/',
  contact_url:                  'https://phlcouncil.com/anthony-phillips/contact/',
  photo_url:                    'https://phlcouncil.com/wp-content/uploads/2024/11/CM-Phillips.jpg',
  twitter_handle:               nil,
  term_start:                   Date.new(2024, 1, 1),
  term_end:                     Date.new(2028, 1, 1),
  attendance_rate_pct:          91,
  bills_introduced_count:       7,
  bills_passed_count:           3,
  party_line_vote_pct:          87,
  data_as_of:                   'March 2026',
  committees: [
    { name: 'Public Safety',             role: 'member' },
    { name: 'Streets & Services',        role: 'member' },
    { name: 'Labor & Civil Service',     role: 'member' }
  ]
)
phillips.save!
puts "Seeded: #{phillips.full_name} (#{phillips.office_title})"

# ── Philadelphia City Council — District 10 ──
oneill = Person.find_or_initialize_by(slug: 'boneill-phl-d10')
oneill.assign_attributes(
  name:                         "Brian O'Neill",
  full_name:                    "Brian J. O'Neill",
  first_name:                   'Brian',
  last_name:                    "O'Neill",
  party:                        'Republican',
  state:                        'PA',
  office_type:                  'city_council',
  office_title:                 'Philadelphia City Councilmember, District 10',
  district_number:              10,
  district_name:                'Far Northeast Philadelphia',
  district_neighborhoods:       ['Somerton', 'Bustleton', 'Modena', 'Rhawnhurst', 'Fox Chase', 'Burholme', 'Pennypack'],
  district_population:          165_000,
  district_neighborhoods_count: 10,
  district_median_income:       62_000,
  district_owner_occupancy_pct: 72,
  district_rco_count:           11,
  office_phone:                 '(215) 686-3418',
  office_address:               'Room 580, City Hall, Philadelphia, PA 19107',
  office_hours:                 'Mon–Fri 9am–5pm',
  website_url:                  "https://phlcouncil.com/brian-oneill/",
  contact_url:                  "https://phlcouncil.com/brian-oneill/contact/",
  photo_url:                    "https://phlcouncil.com/wp-content/uploads/2020/02/Councilmember-Brian-ONeill.jpg",
  twitter_handle:               'BrianONeillD10',
  term_start:                   Date.new(1988, 1, 1),
  term_end:                     Date.new(2028, 1, 1),
  attendance_rate_pct:          90,
  bills_introduced_count:       30,
  bills_passed_count:           17,
  party_line_vote_pct:          60,
  data_as_of:                   'March 2026',
  committees: [
    { name: 'Judiciary',                       role: 'member' },
    { name: 'Licenses & Inspections',          role: 'member' },
    { name: 'Streets & Services',              role: 'member' }
  ]
)
oneill.save!
puts "Seeded: #{oneill.full_name} (#{oneill.office_title})"

# ── Philadelphia City Council — At-Large ──
kgr = Person.find_or_initialize_by(slug: 'kgrichardson-phl-al')
kgr.assign_attributes(
  name:                         'Katherine Gilmore Richardson',
  full_name:                    'Katherine Gilmore Richardson',
  first_name:                   'Katherine',
  last_name:                    'Gilmore Richardson',
  party:                        'Democrat',
  state:                        'PA',
  office_type:                  'city_council_at_large',
  office_title:                 'Philadelphia City Councilmember At-Large',
  district_number:              nil,
  district_name:                'Citywide',
  district_neighborhoods:       [],
  district_population:          1_567_000,
  district_neighborhoods_count: nil,
  district_median_income:       nil,
  district_owner_occupancy_pct: nil,
  district_rco_count:           nil,
  office_phone:                 '(215) 686-3420',
  office_address:               'Room 580, City Hall, Philadelphia, PA 19107',
  office_hours:                 'Mon–Fri 9am–5pm',
  website_url:                  'https://phlcouncil.com/katherine-gilmore-richardson/',
  contact_url:                  'https://phlcouncil.com/katherine-gilmore-richardson/contact/',
  photo_url:                    'https://phlcouncil.com/wp-content/uploads/2020/02/Katherine-Gilmore-Richardson1.jpg',
  twitter_handle:               'KGRforPhilly',
  term_start:                   Date.new(2020, 1, 1),
  term_end:                     Date.new(2028, 1, 1),
  attendance_rate_pct:          94,
  bills_introduced_count:       22,
  bills_passed_count:           12,
  party_line_vote_pct:          90,
  data_as_of:                   'March 2026',
  committees: [
    { name: 'Finance',                                          role: 'chair'  },
    { name: 'Budget & Finance',                                 role: 'member' },
    { name: 'Housing, Neighborhood Development & the Homeless', role: 'member' }
  ]
)
kgr.save!
puts "Seeded: #{kgr.full_name} (#{kgr.office_title})"

ithomas = Person.find_or_initialize_by(slug: 'ithomas-phl-al')
ithomas.assign_attributes(
  name:                         'Isaiah Thomas',
  full_name:                    'Isaiah Thomas',
  first_name:                   'Isaiah',
  last_name:                    'Thomas',
  party:                        'Democrat',
  state:                        'PA',
  office_type:                  'city_council_at_large',
  office_title:                 'Philadelphia City Councilmember At-Large',
  district_number:              nil,
  district_name:                'Citywide',
  district_neighborhoods:       [],
  district_population:          1_567_000,
  district_neighborhoods_count: nil,
  district_median_income:       nil,
  district_owner_occupancy_pct: nil,
  district_rco_count:           nil,
  office_phone:                 '(215) 686-3422',
  office_address:               'Room 580, City Hall, Philadelphia, PA 19107',
  office_hours:                 'Mon–Fri 9am–5pm',
  website_url:                  'https://phlcouncil.com/isaiah-thomas/',
  contact_url:                  'https://phlcouncil.com/isaiah-thomas/contact/',
  photo_url:                    'https://phlcouncil.com/wp-content/uploads/2020/02/Councilmember-Isaiah-Thomas.jpg',
  twitter_handle:               'IsaiahThomasPHL',
  term_start:                   Date.new(2016, 1, 1),
  term_end:                     Date.new(2028, 1, 1),
  attendance_rate_pct:          91,
  bills_introduced_count:       20,
  bills_passed_count:           11,
  party_line_vote_pct:          88,
  data_as_of:                   'March 2026',
  committees: [
    { name: 'Public Safety',                  role: 'chair'  },
    { name: 'Labor & Civil Service',          role: 'member' },
    { name: 'Commerce & Economic Development', role: 'member' }
  ]
)
ithomas.save!
puts "Seeded: #{ithomas.full_name} (#{ithomas.office_title})"

jharrity = Person.find_or_initialize_by(slug: 'jharrity-phl-al')
jharrity.assign_attributes(
  name:                         'Jim Harrity',
  full_name:                    'Jim Harrity',
  first_name:                   'Jim',
  last_name:                    'Harrity',
  party:                        'Democrat',
  state:                        'PA',
  office_type:                  'city_council_at_large',
  office_title:                 'Philadelphia City Councilmember At-Large',
  district_number:              nil,
  district_name:                'Citywide',
  district_neighborhoods:       [],
  district_population:          1_567_000,
  district_neighborhoods_count: nil,
  district_median_income:       nil,
  district_owner_occupancy_pct: nil,
  district_rco_count:           nil,
  office_phone:                 '(215) 686-3424',
  office_address:               'Room 580, City Hall, Philadelphia, PA 19107',
  office_hours:                 'Mon–Fri 9am–5pm',
  website_url:                  'https://phlcouncil.com/jim-harrity/',
  contact_url:                  'https://phlcouncil.com/jim-harrity/contact/',
  photo_url:                    'https://phlcouncil.com/wp-content/uploads/2022/12/Councilmember-Jim-Harrity.jpg',
  twitter_handle:               nil,
  term_start:                   Date.new(2022, 1, 1),
  term_end:                     Date.new(2028, 1, 1),
  attendance_rate_pct:          89,
  bills_introduced_count:       14,
  bills_passed_count:           7,
  party_line_vote_pct:          87,
  data_as_of:                   'March 2026',
  committees: [
    { name: 'Labor & Civil Service',     role: 'chair'  },
    { name: 'Public Safety',             role: 'member' },
    { name: 'Streets & Services',        role: 'member' }
  ]
)
jharrity.save!
puts "Seeded: #{jharrity.full_name} (#{jharrity.office_title})"

nahmad = Person.find_or_initialize_by(slug: 'nahmad-phl-al')
nahmad.assign_attributes(
  name:                         'Nina Ahmad',
  full_name:                    'Nina Ahmad',
  first_name:                   'Nina',
  last_name:                    'Ahmad',
  party:                        'Democrat',
  state:                        'PA',
  office_type:                  'city_council_at_large',
  office_title:                 'Philadelphia City Councilmember At-Large',
  district_number:              nil,
  district_name:                'Citywide',
  district_neighborhoods:       [],
  district_population:          1_567_000,
  district_neighborhoods_count: nil,
  district_median_income:       nil,
  district_owner_occupancy_pct: nil,
  district_rco_count:           nil,
  office_phone:                 '(215) 686-3426',
  office_address:               'Room 580, City Hall, Philadelphia, PA 19107',
  office_hours:                 'Mon–Fri 9am–5pm',
  website_url:                  'https://phlcouncil.com/nina-ahmad/',
  contact_url:                  'https://phlcouncil.com/nina-ahmad/contact/',
  photo_url:                    'https://phlcouncil.com/wp-content/uploads/2024/11/CM-Ahmad-.jpg',
  twitter_handle:               'NinaAhmadPhilly',
  term_start:                   Date.new(2024, 1, 1),
  term_end:                     Date.new(2028, 1, 1),
  attendance_rate_pct:          93,
  bills_introduced_count:       9,
  bills_passed_count:           4,
  party_line_vote_pct:          91,
  data_as_of:                   'March 2026',
  committees: [
    { name: 'Public Health & Human Services',    role: 'member' },
    { name: 'Commerce & Economic Development',   role: 'member' },
    { name: 'Judiciary',                         role: 'member' }
  ]
)
nahmad.save!
puts "Seeded: #{nahmad.full_name} (#{nahmad.office_title})"

rlandau = Person.find_or_initialize_by(slug: 'rlandau-phl-al')
rlandau.assign_attributes(
  name:                         'Rue Landau',
  full_name:                    'Rue Landau',
  first_name:                   'Rue',
  last_name:                    'Landau',
  party:                        'Democrat',
  state:                        'PA',
  office_type:                  'city_council_at_large',
  office_title:                 'Philadelphia City Councilmember At-Large',
  district_number:              nil,
  district_name:                'Citywide',
  district_neighborhoods:       [],
  district_population:          1_567_000,
  district_neighborhoods_count: nil,
  district_median_income:       nil,
  district_owner_occupancy_pct: nil,
  district_rco_count:           nil,
  office_phone:                 '(215) 686-3428',
  office_address:               'Room 580, City Hall, Philadelphia, PA 19107',
  office_hours:                 'Mon–Fri 9am–5pm',
  website_url:                  'https://phlcouncil.com/rue-landau/',
  contact_url:                  'https://phlcouncil.com/rue-landau/contact/',
  photo_url:                    'https://phlcouncil.com/wp-content/uploads/2024/01/Coucilmember-Rue-Landau.jpg',
  twitter_handle:               'RueLandau',
  term_start:                   Date.new(2024, 1, 1),
  term_end:                     Date.new(2028, 1, 1),
  attendance_rate_pct:          95,
  bills_introduced_count:       10,
  bills_passed_count:           5,
  party_line_vote_pct:          92,
  data_as_of:                   'March 2026',
  committees: [
    { name: 'Judiciary',                                        role: 'chair'  },
    { name: 'Public Health & Human Services',                   role: 'member' },
    { name: 'Housing, Neighborhood Development & the Homeless', role: 'member' }
  ]
)
rlandau.save!
puts "Seeded: #{rlandau.full_name} (#{rlandau.office_title})"

kbrooks = Person.find_or_initialize_by(slug: 'kbrooks-phl-al')
kbrooks.assign_attributes(
  name:                         'Kendra Brooks',
  full_name:                    'Kendra Brooks',
  first_name:                   'Kendra',
  last_name:                    'Brooks',
  party:                        'Working Families Party',
  state:                        'PA',
  office_type:                  'city_council_at_large',
  office_title:                 'Philadelphia City Councilmember At-Large',
  district_number:              nil,
  district_name:                'Citywide',
  district_neighborhoods:       [],
  district_population:          1_567_000,
  district_neighborhoods_count: nil,
  district_median_income:       nil,
  district_owner_occupancy_pct: nil,
  district_rco_count:           nil,
  office_phone:                 '(215) 686-3430',
  office_address:               'Room 580, City Hall, Philadelphia, PA 19107',
  office_hours:                 'Mon–Fri 9am–5pm',
  website_url:                  'https://phlcouncil.com/kendra-brooks/',
  contact_url:                  'https://phlcouncil.com/kendra-brooks/contact/',
  photo_url:                    'https://phlcouncil.com/wp-content/uploads/2023/02/Councilmember-Kendra-Brooks.jpg',
  twitter_handle:               'KendraBrooksPHL',
  term_start:                   Date.new(2020, 1, 1),
  term_end:                     Date.new(2028, 1, 1),
  attendance_rate_pct:          96,
  bills_introduced_count:       25,
  bills_passed_count:           13,
  party_line_vote_pct:          72,
  data_as_of:                   'March 2026',
  committees: [
    { name: 'Housing, Neighborhood Development & the Homeless', role: 'member' },
    { name: 'Public Health & Human Services',                   role: 'member' },
    { name: 'Labor & Civil Service',                            role: 'member' }
  ]
)
kbrooks.save!
puts "Seeded: #{kbrooks.full_name} (#{kbrooks.office_title})"

norourke = Person.find_or_initialize_by(slug: 'norourke-phl-al')
norourke.assign_attributes(
  name:                         "Nicolas O'Rourke",
  full_name:                    "Nicolas O'Rourke",
  first_name:                   'Nicolas',
  last_name:                    "O'Rourke",
  party:                        'Working Families Party',
  state:                        'PA',
  office_type:                  'city_council_at_large',
  office_title:                 'Philadelphia City Councilmember At-Large',
  district_number:              nil,
  district_name:                'Citywide',
  district_neighborhoods:       [],
  district_population:          1_567_000,
  district_neighborhoods_count: nil,
  district_median_income:       nil,
  district_owner_occupancy_pct: nil,
  district_rco_count:           nil,
  office_phone:                 '(215) 686-3432',
  office_address:               'Room 580, City Hall, Philadelphia, PA 19107',
  office_hours:                 'Mon–Fri 9am–5pm',
  website_url:                  "https://phlcouncil.com/nicolas-orourke/",
  contact_url:                  "https://phlcouncil.com/nicolas-orourke/contact/",
  photo_url:                    "https://phlcouncil.com/wp-content/uploads/2024/01/Councilmember-Nick-ORourke.jpg",
  twitter_handle:               'NickORourkeWFP',
  term_start:                   Date.new(2024, 1, 1),
  term_end:                     Date.new(2028, 1, 1),
  attendance_rate_pct:          94,
  bills_introduced_count:       8,
  bills_passed_count:           3,
  party_line_vote_pct:          70,
  data_as_of:                   'March 2026',
  committees: [
    { name: 'Housing, Neighborhood Development & the Homeless', role: 'member' },
    { name: 'Commerce & Economic Development',                  role: 'member' },
    { name: 'Streets & Services',                               role: 'member' }
  ]
)
norourke.save!
puts "Seeded: #{norourke.full_name} (#{norourke.office_title})"

# ── Philadelphia Managing Director ──
thiel = Person.find_or_initialize_by(slug: 'athiel-philly-md')
thiel.assign_attributes(
  name:         'Adam Thiel',
  full_name:    'Adam Thiel',
  first_name:   'Adam',
  last_name:    'Thiel',
  party:        nil,
  state:        'PA',
  office_type:  'managing_director',
  office_title: 'Managing Director of Philadelphia',
  term_start:   Date.new(2024, 1, 1),
  website_url:  'https://www.phila.gov/departments/office-of-the-managing-director/',
  data_as_of:   'March 2026',
  policy_priorities: [
    { name: 'City operations & service delivery', level: 'high',   color: '#378add' },
    { name: 'Emergency management',               level: 'high',   color: '#a32d2d' },
    { name: 'Interdepartmental coordination',     level: 'high',   color: '#1d9e75' },
    { name: 'Infrastructure & public works',      level: 'medium', color: '#ba7517' }
  ]
)
thiel.save!
puts "Seeded: #{thiel.full_name} (#{thiel.office_title})"

# ── Philadelphia Director of Finance ──
dubow = Person.find_or_initialize_by(slug: 'rdubow-philly-finance')
dubow.assign_attributes(
  name:         'Rob Dubow',
  full_name:    'Rob Dubow',
  first_name:   'Rob',
  last_name:    'Dubow',
  party:        nil,
  state:        'PA',
  office_type:  'finance_director',
  office_title: 'Director of Finance, City of Philadelphia',
  term_start:   Date.new(2008, 1, 1),
  website_url:  'https://www.phila.gov/departments/department-of-revenue/',
  data_as_of:   'March 2026',
  policy_priorities: [
    { name: 'City budget & fiscal policy',        level: 'high',   color: '#378add' },
    { name: 'Debt management & bond issuance',    level: 'high',   color: '#534ab7' },
    { name: 'Revenue forecasting',                level: 'high',   color: '#1d9e75' },
    { name: 'Pension fund oversight',             level: 'medium', color: '#ba7517' }
  ]
)
dubow.save!
puts "Seeded: #{dubow.full_name} (#{dubow.office_title})"
