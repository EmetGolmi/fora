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
