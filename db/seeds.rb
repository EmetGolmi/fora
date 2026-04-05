# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

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
  budget_breakdown: { education: 35, health: 30, transportation: 18, safety: 10, other: 7 },
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
    { bill: 'HB 1190', title: 'Constitutional carry',    note: 'Permitless concealed carry — vetoed Jul 2023',                         outcome: 'vetoed' },
    { bill: 'SB 292',  title: 'Voter ID expansion',      note: 'Expanded photo ID requirements — vetoed Jun 2024',                     outcome: 'vetoed' },
    { bill: 'SB 1',    title: 'School choice vouchers',  note: 'PASS voucher program — vetoed Jun 2023 · Override attempt failed',      outcome: 'vetoed' }
  ],
  data_as_of: 'March 2026'
)
shapiro.save!
puts "Seeded: #{shapiro.full_name} (#{shapiro.office_title})"
