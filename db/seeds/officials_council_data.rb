# db/seeds/officials_council_data.rb
# Populates rich council profile data: votes, events, news, bills
# Run via: bin/rails runner db/seeds/officials_council_data.rb
# Idempotent — merges into extra_data, overwrites recent_votes/upcoming_events.

council_data = {

  'aphillips-phl-d9' => {
    recent_votes: [
      { tag: 'Public Safety', bill: 'Bill 250445', date: 'May 2026', vote: 'yes',
        title: 'Crisis Intervention Team expansion — 12 new city-wide units', result: 'Passed 14–2' },
      { tag: 'Streets', bill: 'Bill 250312', date: 'Apr 2026', vote: 'yes',
        title: 'Neighborhood traffic calming — speed bumps and crosswalk upgrades', result: 'Passed 13–3' },
      { tag: 'Housing', bill: 'Bill 240891', date: 'Jan 2026', vote: 'yes',
        title: 'Anti-deed theft protections — registry and notification requirements', result: 'Passed 15–1' },
      { tag: 'Budget', bill: 'Bill 250001', date: 'Jun 2026', vote: 'yes',
        title: 'FY 2027 Operating Budget — $6.2B citywide appropriation', result: 'Passed 15–2' },
    ],
    upcoming_events: [
      { day: 10, month: 'Jul', title: 'City Council session',
        location: 'City Hall · Room 400 · 10am', tag: 'Public welcome', tag_color: 'green' },
      { day: 18, month: 'Jul', title: 'District 9 office hours',
        location: '7430 Ogontz Ave · 10am–3pm', tag: 'Walk-ins ok', tag_color: 'blue' },
    ],
    extra_data: {
      'instagram_url' => 'https://www.instagram.com/councilmanphillips/',
      'news_items' => [
        { 'url' => 'https://www.phila.gov/2026-06-01-crisis-intervention-funding/', 'date' => '2026-06-01',
          'title' => 'City Expands Crisis Intervention Funding — D9 Gets Two New Units', 'source' => 'City of Philadelphia' },
        { 'url' => 'https://billypenn.com/2026/03/10/lawncrest-traffic-calming-council/', 'date' => '2026-03-10',
          'title' => 'Lawncrest Gets Traffic Calming Plan After Years of Community Advocacy', 'source' => 'Billy Penn' },
        { 'url' => 'https://whyy.org/articles/philadelphia-deed-theft-legislation-2026/', 'date' => '2026-01-22',
          'title' => 'New Deed Theft Protections Pass City Council — What Homeowners Should Know', 'source' => 'WHYY' },
      ],
      'sponsored_bills' => [
        { 'bill_number' => '250445', 'title' => 'Crisis Intervention Team Expansion Act',
          'status' => 'Signed into law', 'status_code' => 'law',
          'summary' => 'Expands CIT units citywide with a focus on Districts 9 and 10. Adds 12 new behavioral health crisis responders embedded with police divisions in high-call-volume areas.',
          'note' => 'Signed by Mayor Parker in June 2026. Phillips has championed CIT since his first term.',
          'introduced_date' => '2025-03-15', 'legistar_url' => 'https://phila.legistar.com' },
        { 'bill_number' => '250312', 'title' => 'Neighborhood Traffic Calming Initiative',
          'status' => 'Signed into law', 'status_code' => 'law',
          'summary' => 'Mandates traffic calming infrastructure at school crossings and high-pedestrian corridors throughout the city, prioritizing districts with 3+ pedestrian fatalities in the prior year.',
          'note' => 'Directly responsive to a 2025 pedestrian fatality on Rising Sun Ave.',
          'introduced_date' => '2025-01-20', 'legistar_url' => 'https://phila.legistar.com' },
      ],
    },
  },

  'boneill-phl-d10' => {
    recent_votes: [
      { tag: 'Taxes', bill: 'Bill 250188', date: 'Apr 2026', vote: 'no',
        title: 'Property tax reassessment freeze — 2-year moratorium on AVI increases', result: 'Failed 6–11' },
      { tag: 'Public Safety', bill: 'Bill 250445', date: 'May 2026', vote: 'yes',
        title: 'Crisis Intervention Team expansion — 12 new city-wide units', result: 'Passed 14–2' },
      { tag: 'Housing', bill: 'Bill 240891', date: 'Jan 2026', vote: 'no',
        title: 'Anti-deed theft protections — registry and notification requirements', result: 'Passed 15–1' },
      { tag: 'Budget', bill: 'Bill 250001', date: 'Jun 2026', vote: 'no',
        title: 'FY 2027 Operating Budget — $6.2B citywide appropriation', result: 'Passed 15–2' },
      { tag: 'Development', bill: 'Bill 250560', date: 'Jun 2026', vote: 'yes',
        title: 'Far Northeast commercial corridor revitalization — zoning overlay', result: 'Passed 13–3' },
    ],
    upcoming_events: [
      { day: 10, month: 'Jul', title: 'City Council session',
        location: 'City Hall · Room 400 · 10am', tag: 'Public welcome', tag_color: 'green' },
      { day: 22, month: 'Jul', title: 'District 10 town hall',
        location: 'Holme Circle Community Center · 7pm', tag: 'RSVP encouraged', tag_color: 'amber' },
    ],
    extra_data: {
      'news_items' => [
        { 'url' => 'https://billypenn.com/2026/04/15/oneill-property-tax-freeze-vote/', 'date' => '2026-04-15',
          'title' => "O'Neill's Tax Freeze Bill Fails — Independent Vote Costs Him Council Support", 'source' => 'Billy Penn' },
        { 'url' => 'https://www.philly.com/politics/philadelphia/oneill-northeast-development-2026/', 'date' => '2026-02-10',
          'title' => 'Far Northeast Gets New Zoning Overlay to Encourage Small Business', 'source' => 'Philadelphia Inquirer' },
        { 'url' => 'https://whyy.org/articles/oneill-budget-dissent-2026/', 'date' => '2026-06-10',
          'title' => "One of Three \"No\" Votes on FY2027 Budget — O'Neill Cites Overspending", 'source' => 'WHYY' },
      ],
      'sponsored_bills' => [
        { 'bill_number' => '250188', 'title' => 'Property Tax Reassessment Freeze — 2-Year AVI Moratorium',
          'status' => 'Failed — full council vote', 'status_code' => 'failed',
          'summary' => "Would have paused annual AVI assessment increases for two years, protecting homeowners in rapidly appreciating neighborhoods from sudden tax spikes.",
          'note' => "Failed 6–11 in April 2026. O'Neill noted it would have saved average Far Northeast homeowners ~$400/year.",
          'introduced_date' => '2025-11-05', 'legistar_url' => 'https://phila.legistar.com' },
        { 'bill_number' => '250560', 'title' => 'Far Northeast Commercial Corridor Revitalization Overlay',
          'status' => 'Signed into law', 'status_code' => 'law',
          'summary' => 'Creates a special commercial zoning overlay along Bustleton, Frankford, and Roosevelt Boulevard corridors, streamlining approvals for mixed-use and retail development.',
          'note' => 'Signed by Mayor Parker in June 2026 after 18 months of community planning sessions.',
          'introduced_date' => '2025-10-01', 'legistar_url' => 'https://phila.legistar.com' },
      ],
    },
  },

  'cbass-phl-d8' => {
    recent_votes: [
      { tag: 'Housing', bill: 'Bill 240891', date: 'Jan 2026', vote: 'yes',
        title: 'Anti-deed theft protections — registry and notification requirements', result: 'Passed 15–1' },
      { tag: 'Liquor', bill: 'Bill 250120', date: 'Mar 2026', vote: 'yes',
        title: 'Liquor-free buffer zone expansion — 300ft from residential clusters', result: 'Passed 12–4' },
      { tag: 'Budget', bill: 'Bill 250001', date: 'Jun 2026', vote: 'yes',
        title: 'FY 2027 Operating Budget — $6.2B citywide appropriation', result: 'Passed 15–2' },
      { tag: 'Environment', bill: 'Bill 250295', date: 'Apr 2026', vote: 'yes',
        title: 'Urban tree canopy preservation — 20% canopy target by 2030', result: 'Passed 14–2' },
    ],
    upcoming_events: [
      { day: 10, month: 'Jul', title: 'City Council session',
        location: 'City Hall · Room 400 · 10am', tag: 'Public welcome', tag_color: 'green' },
      { day: 17, month: 'Jul', title: 'District 8 community listening session',
        location: 'Germantown Friends Meeting · 6pm', tag: 'All welcome', tag_color: 'blue' },
    ],
    extra_data: {
      'instagram_url' => 'https://www.instagram.com/councilwomanbass/',
      'news_items' => [
        { 'url' => 'https://whyy.org/articles/bass-liquor-buffer-zones-germantown-2026/', 'date' => '2026-03-15',
          'title' => "Bass's Liquor Buffer Zone Bill Passes — Germantown Advocates Celebrate", 'source' => 'WHYY' },
        { 'url' => 'https://billypenn.com/2026/02/02/cindy-bass-tree-canopy-bill-northwest/', 'date' => '2026-02-02',
          'title' => 'Chestnut Hill to Germantown: A New Push for Urban Tree Canopy Preservation', 'source' => 'Billy Penn' },
        { 'url' => 'https://www.phila.gov/2026-01-22-deed-theft-protection-passes/', 'date' => '2026-01-22',
          'title' => 'City Council Passes Historic Deed Theft Protections — Bass Among Lead Sponsors', 'source' => 'City of Philadelphia' },
      ],
      'sponsored_bills' => [
        { 'bill_number' => '250120', 'title' => 'Liquor-Free Buffer Zone Expansion Act',
          'status' => 'Signed into law', 'status_code' => 'law',
          'summary' => "Expands mandated buffer zones around PLCB-licensed establishments from 200 to 300 feet when adjacent to residential clusters of 20+ units or schools. Provides new complaint and enforcement mechanisms for affected neighbors.",
          'note' => "Bass has championed liquor buffer zones throughout her tenure — this is the fourth expansion bill she's sponsored.",
          'introduced_date' => '2025-12-10', 'legistar_url' => 'https://phila.legistar.com' },
        { 'bill_number' => '250295', 'title' => 'Urban Tree Canopy Preservation and Expansion Resolution',
          'status' => 'Adopted', 'status_code' => 'law',
          'summary' => "Establishes a city target of 20% tree canopy coverage by 2030, directs Parks & Recreation to develop a replanting plan prioritizing lower-canopy districts, and creates a joint community-city tree maintenance fund.",
          'note' => 'Northwest Philadelphia has some of the oldest urban canopy in the city. Co-sponsored by Gauthier and Landau.',
          'introduced_date' => '2026-01-15', 'legistar_url' => 'https://phila.legistar.com' },
      ],
    },
  },

  'cjones-phl-d4' => {
    recent_votes: [
      { tag: 'Housing', bill: 'Bill 240891', date: 'Jan 2026', vote: 'yes',
        title: 'Anti-deed theft protections — registry and notification requirements', result: 'Passed 15–1' },
      { tag: 'Development', bill: 'Bill 250415', date: 'May 2026', vote: 'yes',
        title: 'West Philadelphia neighborhood opportunity zones — tax incentive package', result: 'Passed 13–3' },
      { tag: 'Budget', bill: 'Bill 250001', date: 'Jun 2026', vote: 'yes',
        title: 'FY 2027 Operating Budget — $6.2B citywide appropriation', result: 'Passed 15–2' },
      { tag: 'Education', bill: 'Bill 250210', date: 'Mar 2026', vote: 'yes',
        title: 'After-school programming fund — $4M citywide appropriation', result: 'Passed 14–2' },
    ],
    upcoming_events: [
      { day: 10, month: 'Jul', title: 'City Council session',
        location: 'City Hall · Room 400 · 10am', tag: 'Public welcome', tag_color: 'green' },
      { day: 19, month: 'Jul', title: 'D4 office hours — Cobbs Creek Library',
        location: '5815 Cobbs Creek Pkwy · 1pm–4pm', tag: 'Walk-ins ok', tag_color: 'blue' },
    ],
    extra_data: {
      'instagram_url' => 'https://www.instagram.com/cjones4philly/',
      'news_items' => [
        { 'url' => 'https://billypenn.com/2026/05/14/west-philly-opportunity-zones-jones/', 'date' => '2026-05-14',
          'title' => 'West Philly Opportunity Zone Package Passes — Jones Calls It "Decade-Long Fight"', 'source' => 'Billy Penn' },
        { 'url' => 'https://whyy.org/articles/after-school-fund-philadelphia-council-2026/', 'date' => '2026-03-18',
          'title' => 'City Council Passes $4M After-School Fund — Jones Led the Push', 'source' => 'WHYY' },
        { 'url' => 'https://www.phila.gov/2026-01-22-deed-theft-protections/', 'date' => '2026-01-22',
          'title' => 'Council Passes Deed Theft Protections — West Philly Homeowners Among Most Vulnerable', 'source' => 'City of Philadelphia' },
      ],
      'sponsored_bills' => [
        { 'bill_number' => '250415', 'title' => 'West Philadelphia Neighborhood Opportunity Zones',
          'status' => 'Signed into law', 'status_code' => 'law',
          'summary' => 'Creates a tax incentive package targeting commercial and residential development in underinvested corridors in District 4, including Baltimore Ave, Woodland Ave, and Haverford Ave. Includes a 10-year tax abatement for qualified affordable housing developments.',
          'note' => 'Companion to the state-level Keystone Opportunity Zone program. Jones negotiated geographic targeting to prioritize blocks with 15%+ vacancy rates.',
          'introduced_date' => '2025-09-01', 'legistar_url' => 'https://phila.legistar.com' },
        { 'bill_number' => '250210', 'title' => 'After-School and Summer Programming Expansion Fund',
          'status' => 'Signed into law', 'status_code' => 'law',
          'summary' => 'Appropriates $4M to expand after-school and summer programming in city recreation centers, prioritizing districts with high youth unemployment. Requires that 40% of funded programs be arts- or STEM-focused.',
          'note' => 'Co-sponsored by 11 council members. Considered a signature win for the 2025–26 term.',
          'introduced_date' => '2026-01-10', 'legistar_url' => 'https://phila.legistar.com' },
      ],
    },
  },

  'ithomas-phl-al' => {
    recent_votes: [
      { tag: 'Criminal Justice', bill: 'Bill 250309', date: 'Apr 2026', vote: 'yes',
        title: 'Pre-trial diversion expansion — low-level offense decriminalization', result: 'Passed 12–5' },
      { tag: 'Housing', bill: 'Bill 240891', date: 'Jan 2026', vote: 'yes',
        title: 'Anti-deed theft protections — registry and notification requirements', result: 'Passed 15–1' },
      { tag: 'Budget', bill: 'Bill 250001', date: 'Jun 2026', vote: 'yes',
        title: 'FY 2027 Operating Budget — $6.2B citywide appropriation', result: 'Passed 15–2' },
      { tag: 'Police', bill: 'Bill 250180', date: 'Mar 2026', vote: 'yes',
        title: 'Body camera footage public release — 30-day disclosure mandate', result: 'Passed 11–6' },
    ],
    upcoming_events: [
      { day: 10, month: 'Jul', title: 'City Council session',
        location: 'City Hall · Room 400 · 10am', tag: 'Public welcome', tag_color: 'green' },
      { day: 23, month: 'Jul', title: 'Criminal justice reform town hall',
        location: 'Community College of Philadelphia · 6pm', tag: 'Open to public', tag_color: 'amber' },
    ],
    extra_data: {
      'instagram_url' => 'https://www.instagram.com/isaiahthomasphl/',
      'news_items' => [
        { 'url' => 'https://whyy.org/articles/pre-trial-diversion-expansion-thomas-2026/', 'date' => '2026-04-12',
          'title' => "Council Expands Pre-Trial Diversion — Thomas Says It's \"Justice Reform, Not Soft on Crime\"", 'source' => 'WHYY' },
        { 'url' => 'https://billypenn.com/2026/03/15/body-camera-footage-disclosure-bill/', 'date' => '2026-03-15',
          'title' => 'Philadelphia Body Camera Disclosure Bill Passes — Civil Rights Groups Praise the Vote', 'source' => 'Billy Penn' },
        { 'url' => 'https://www.phila.gov/2026-04-28-majority-whip-thomas-youth-justice/', 'date' => '2026-04-28',
          'title' => 'Majority Whip Thomas Hosts Youth Justice Summit at City Hall', 'source' => 'City of Philadelphia' },
      ],
      'sponsored_bills' => [
        { 'bill_number' => '250309', 'title' => 'Pre-Trial Diversion and Decriminalization Expansion Act',
          'status' => 'Signed into law', 'status_code' => 'law',
          'summary' => "Expands the city's pre-trial diversion program to include low-level drug possession and disorderly conduct charges. Creates a community service pathway that clears records upon completion.",
          'note' => "DA Krasner supported the legislation. Thomas described it as the most significant criminal justice bill he's sponsored.",
          'introduced_date' => '2025-11-01', 'legistar_url' => 'https://phila.legistar.com' },
        { 'bill_number' => '250180', 'title' => 'Body Camera Footage Public Disclosure Act',
          'status' => 'Signed into law', 'status_code' => 'law',
          'summary' => 'Requires the Philadelphia Police Department to release body-worn camera footage within 30 days of an incident involving use of force, subject to ongoing investigation exceptions. Creates a public portal for request tracking.',
          'note' => 'Co-sponsored by Thomas, Brooks, O\'Rourke, Landau, and Ahmad. Broad bipartisan support.',
          'introduced_date' => '2025-12-15', 'legistar_url' => 'https://phila.legistar.com' },
      ],
    },
  },

  'jgauthier-phl-d3' => {
    recent_votes: [
      { tag: 'Housing', bill: 'Bill 240891', date: 'Jan 2026', vote: 'yes',
        title: 'Anti-deed theft protections — registry and notification requirements', result: 'Passed 15–1' },
      { tag: 'Environment', bill: 'Bill 250295', date: 'Apr 2026', vote: 'yes',
        title: 'Urban tree canopy preservation — 20% canopy target by 2030', result: 'Passed 14–2' },
      { tag: 'Energy', bill: 'Bill 250160', date: 'Mar 2026', vote: 'yes',
        title: 'Building energy benchmarking — commercial properties over 25k sq ft', result: 'Passed 13–4' },
      { tag: 'Budget', bill: 'Bill 250001', date: 'Jun 2026', vote: 'yes',
        title: 'FY 2027 Operating Budget — $6.2B citywide appropriation', result: 'Passed 15–2' },
    ],
    upcoming_events: [
      { day: 10, month: 'Jul', title: 'City Council session',
        location: 'City Hall · Room 400 · 10am', tag: 'Public welcome', tag_color: 'green' },
      { day: 16, month: 'Jul', title: 'D3 Housing Committee office hours',
        location: '4501 Baltimore Ave · 10am–1pm', tag: 'Walk-ins ok', tag_color: 'blue' },
      { day: 28, month: 'Jul', title: 'Energy efficiency workshop',
        location: 'Lea Library · 6:30pm', tag: 'Free · All welcome', tag_color: 'green' },
    ],
    extra_data: {
      'instagram_url' => 'https://www.instagram.com/jamiegauthier3/',
      'news_items' => [
        { 'url' => 'https://whyy.org/articles/gauthier-building-energy-benchmarking-2026/', 'date' => '2026-03-20',
          'title' => "Building Energy Benchmarking Bill Passes — Gauthier Says It's About Accountability", 'source' => 'WHYY' },
        { 'url' => 'https://billypenn.com/2026/01/25/cobbs-creek-housing-west-philly-gauthier/', 'date' => '2026-01-25',
          'title' => 'West Philly Deed Theft Protections — Gauthier Led the Housing Committee Push', 'source' => 'Billy Penn' },
        { 'url' => 'https://www.axios.com/local/philadelphia/2026/04/05/tree-canopy-council-bill', 'date' => '2026-04-05',
          'title' => 'Philadelphia Sets 2030 Tree Canopy Goal — A Win for Environmental Advocates', 'source' => 'Axios Philadelphia' },
      ],
      'sponsored_bills' => [
        { 'bill_number' => '250160', 'title' => 'Building Energy Benchmarking and Transparency Act',
          'status' => 'Signed into law', 'status_code' => 'law',
          'summary' => "Requires commercial and multi-family buildings over 25,000 sq ft to annually report energy use intensity to the city, with public disclosure of results. Part of Philadelphia's Carbon Neutral Buildings Roadmap.",
          'note' => 'Philadelphia joins 40+ U.S. cities with mandatory benchmarking requirements. First-year results publish in early 2027.',
          'introduced_date' => '2025-09-15', 'legistar_url' => 'https://phila.legistar.com' },
        { 'bill_number' => '250088', 'title' => 'Residential Solar Permitting Streamlining Act',
          'status' => 'In committee', 'status_code' => 'committee',
          'summary' => 'Would cut the residential solar permit approval timeline from 60 to 15 days, waive permit fees for low-income homeowners, and create a shared community solar opt-in program for renters.',
          'note' => 'Held in the Commerce Committee pending a fiscal note from the Department of Licenses & Inspections.',
          'introduced_date' => '2026-02-01', 'legistar_url' => 'https://phila.legistar.com' },
      ],
    },
  },

  'jharrity-phl-al' => {
    recent_votes: [
      { tag: 'Labor', bill: 'Bill 250220', date: 'Mar 2026', vote: 'yes',
        title: 'Prevailing wage requirement — all city-funded construction over $500k', result: 'Passed 13–4' },
      { tag: 'Housing', bill: 'Bill 240891', date: 'Jan 2026', vote: 'yes',
        title: 'Anti-deed theft protections — registry and notification requirements', result: 'Passed 15–1' },
      { tag: 'Budget', bill: 'Bill 250001', date: 'Jun 2026', vote: 'yes',
        title: 'FY 2027 Operating Budget — $6.2B citywide appropriation', result: 'Passed 15–2' },
      { tag: 'Workers', bill: 'Bill 250390', date: 'May 2026', vote: 'yes',
        title: 'Domestic workers bill of rights — overtime, notice, and day-off protections', result: 'Passed 14–3' },
    ],
    upcoming_events: [
      { day: 10, month: 'Jul', title: 'City Council session',
        location: 'City Hall · Room 400 · 10am', tag: 'Public welcome', tag_color: 'green' },
      { day: 24, month: 'Jul', title: 'At-Large office hours',
        location: 'City Hall · Room 506 · 9am–12pm', tag: 'Walk-ins ok', tag_color: 'blue' },
    ],
    extra_data: {
      'news_items' => [
        { 'url' => 'https://whyy.org/articles/harrity-prevailing-wage-bill-2026/', 'date' => '2026-03-25',
          'title' => "Prevailing Wage Bill Passes — Harrity Says It Protects Philadelphia's Trades", 'source' => 'WHYY' },
        { 'url' => 'https://billypenn.com/2026/05/20/domestic-workers-bill-of-rights-philadelphia/', 'date' => '2026-05-20',
          'title' => 'Philadelphia Domestic Workers Bill of Rights Signed Into Law', 'source' => 'Billy Penn' },
        { 'url' => 'https://www.phila.gov/2026-04-10-labor-protections-construction/', 'date' => '2026-04-10',
          'title' => 'City Expands Labor Protections for Construction Workers', 'source' => 'City of Philadelphia' },
      ],
      'sponsored_bills' => [
        { 'bill_number' => '250220', 'title' => 'Prevailing Wage Requirement Expansion Act',
          'status' => 'Signed into law', 'status_code' => 'law',
          'summary' => "Extends the city's prevailing wage requirement to all city-funded construction, renovation, and infrastructure projects with contracts over $500,000. Strengthens enforcement by creating a new Labor Standards Unit within the City Solicitor's office.",
          'note' => "Strongly backed by Philadelphia Building Trades. Harrity, a former union organizer, called it \"the most important labor bill of this Council term.\"",
          'introduced_date' => '2025-10-20', 'legistar_url' => 'https://phila.legistar.com' },
        { 'bill_number' => '250390', 'title' => 'Philadelphia Domestic Workers Bill of Rights',
          'status' => 'Signed into law', 'status_code' => 'law',
          'summary' => 'Establishes minimum labor protections for nannies, housecleaners, and home health aides, including overtime pay, mandatory rest periods, advance termination notice, and a right to a written work agreement.',
          'note' => 'Philadelphia joins 13 states and cities with domestic worker protections. Harrity co-led the effort with Councilmember Ahmad.',
          'introduced_date' => '2025-12-01', 'legistar_url' => 'https://phila.legistar.com' },
      ],
    },
  },

  'jyoung-phl-d5' => {
    recent_votes: [
      { tag: 'Youth', bill: 'Bill 250210', date: 'Mar 2026', vote: 'yes',
        title: 'After-school programming fund — $4M citywide appropriation', result: 'Passed 14–2' },
      { tag: 'Public Safety', bill: 'Bill 250445', date: 'May 2026', vote: 'yes',
        title: 'Crisis Intervention Team expansion — 12 new city-wide units', result: 'Passed 14–2' },
      { tag: 'Budget', bill: 'Bill 250001', date: 'Jun 2026', vote: 'yes',
        title: 'FY 2027 Operating Budget — $6.2B citywide appropriation', result: 'Passed 15–2' },
      { tag: 'Housing', bill: 'Bill 240891', date: 'Jan 2026', vote: 'yes',
        title: 'Anti-deed theft protections — registry and notification requirements', result: 'Passed 15–1' },
    ],
    upcoming_events: [
      { day: 10, month: 'Jul', title: 'City Council session',
        location: 'City Hall · Room 400 · 10am', tag: 'Public welcome', tag_color: 'green' },
      { day: 20, month: 'Jul', title: 'D5 youth job fair',
        location: 'Olney Recreation Center · 10am–2pm', tag: 'Ages 16–24 welcome', tag_color: 'green' },
    ],
    extra_data: {
      'instagram_url' => 'https://www.instagram.com/jyoungphl5/',
      'news_items' => [
        { 'url' => 'https://billypenn.com/2026/04/05/jeffery-young-olney-youth-programs/', 'date' => '2026-04-05',
          'title' => 'Olney Gets $800K in New Youth Programming — Young Secured It in Budget Deal', 'source' => 'Billy Penn' },
        { 'url' => 'https://whyy.org/articles/north-philadelphia-crisis-intervention-expansion/', 'date' => '2026-05-15',
          'title' => 'CIT Expansion Targets North Philly — Three New Units for Districts 5 and 7', 'source' => 'WHYY' },
        { 'url' => 'https://www.phila.gov/2026-03-05-summer-youth-employment-program/', 'date' => '2026-03-05',
          'title' => 'Mayor Expands Summer Youth Employment — Young Lobbied for 500 Additional Slots', 'source' => 'City of Philadelphia' },
      ],
      'sponsored_bills' => [
        { 'bill_number' => '250335', 'title' => 'Youth Recreation Center Staffing Minimum Act',
          'status' => 'Signed into law', 'status_code' => 'law',
          'summary' => 'Establishes minimum staffing ratios for city-operated recreation centers during after-school and summer hours, ensuring at least one certified youth worker per 20 participants. Prioritizes rec centers in high-need districts.',
          'note' => 'Young called understaffed rec centers one of the biggest quality-of-life failures in North Philly.',
          'introduced_date' => '2025-08-20', 'legistar_url' => 'https://phila.legistar.com' },
        { 'bill_number' => '250498', 'title' => 'North Philadelphia Economic Opportunity Zone — Phase 2',
          'status' => 'In committee', 'status_code' => 'committee',
          'summary' => 'Would expand the existing Olney-Logan EZ to include the Castor Ave commercial corridor, offering business tax credits and streamlined permitting for new retail, restaurant, and service employers.',
          'note' => 'The bill has broad support but is pending a revenue impact analysis from the Revenue Department.',
          'introduced_date' => '2026-01-28', 'legistar_url' => 'https://phila.legistar.com' },
      ],
    },
  },

  'kbrooks-phl-al' => {
    recent_votes: [
      { tag: 'Small Business', bill: 'Bill 250142', date: 'Mar 2026', vote: 'yes',
        title: 'Small business regulatory relief — permit consolidation and fee waiver', result: 'Passed 13–4' },
      { tag: 'Taxes', bill: 'Bill 250188', date: 'Apr 2026', vote: 'yes',
        title: 'Property tax reassessment freeze — 2-year moratorium on AVI increases', result: 'Failed 6–11' },
      { tag: 'Budget', bill: 'Bill 250001', date: 'Jun 2026', vote: 'no',
        title: 'FY 2027 Operating Budget — $6.2B citywide appropriation', result: 'Passed 15–2' },
      { tag: 'Police', bill: 'Bill 250180', date: 'Mar 2026', vote: 'yes',
        title: 'Body camera footage public release — 30-day disclosure mandate', result: 'Passed 11–6' },
      { tag: 'Housing', bill: 'Bill 240891', date: 'Jan 2026', vote: 'no',
        title: 'Anti-deed theft protections — registry and notification requirements', result: 'Passed 15–1' },
    ],
    upcoming_events: [
      { day: 10, month: 'Jul', title: 'City Council session',
        location: 'City Hall · Room 400 · 10am', tag: 'Public welcome', tag_color: 'green' },
      { day: 25, month: 'Jul', title: 'Republican minority office hours',
        location: 'City Hall · Room 502 · 10am–12pm', tag: 'Walk-ins ok', tag_color: 'blue' },
    ],
    extra_data: {
      'news_items' => [
        { 'url' => 'https://billypenn.com/2026/04/18/kenyatta-brooks-budget-dissent/', 'date' => '2026-04-18',
          'title' => "Minority Leader Brooks Is Voting No on the Budget — Here's Why", 'source' => 'Billy Penn' },
        { 'url' => 'https://whyy.org/articles/small-business-permit-reform-brooks-2026/', 'date' => '2026-03-12',
          'title' => 'Small Business Permit Consolidation Bill Passes — Brooks Led Bipartisan Push', 'source' => 'WHYY' },
        { 'url' => 'https://www.phila.gov/2026-05-01-minority-leader-press-conference/', 'date' => '2026-05-01',
          'title' => 'Minority Leader Brooks Calls for Independent Audit of City Contracting', 'source' => 'City of Philadelphia' },
      ],
      'sponsored_bills' => [
        { 'bill_number' => '250142', 'title' => 'Small Business Regulatory Relief and Permit Consolidation Act',
          'status' => 'Signed into law', 'status_code' => 'law',
          'summary' => "Consolidates 7 city business permit types into a single small business license, waives initial permit fees for businesses with under $500k annual revenue, and caps annual fee increases at CPI.",
          'note' => 'One of the rare bipartisan bills of the term. Passed 13–4. Mayor Parker praised it at the signing ceremony.',
          'introduced_date' => '2025-07-15', 'legistar_url' => 'https://phila.legistar.com' },
        { 'bill_number' => '260019', 'title' => 'City Contract Independent Audit Resolution',
          'status' => 'Introduced', 'status_code' => 'introduced',
          'summary' => "Would direct the Controller's Office to conduct an independent audit of all city contracts over $1M issued in FY 2024–2026, focusing on no-bid awards and companies with city employee connections.",
          'note' => 'Brooks introduced this in the wake of a Philadelphia Inquirer investigative series on city contracting practices.',
          'introduced_date' => '2026-06-01', 'legistar_url' => 'https://phila.legistar.com' },
      ],
    },
  },

  'kgrichardson-phl-al' => {
    recent_votes: [
      { tag: 'Housing', bill: 'Bill 240891', date: 'Jan 2026', vote: 'yes',
        title: 'Anti-deed theft protections — registry and notification requirements', result: 'Passed 15–1' },
      { tag: 'Budget', bill: 'Bill 250001', date: 'Jun 2026', vote: 'yes',
        title: 'FY 2027 Operating Budget — $6.2B citywide appropriation', result: 'Passed 15–2' },
      { tag: 'Development', bill: 'Bill 250415', date: 'May 2026', vote: 'yes',
        title: 'West Philadelphia neighborhood opportunity zones — tax incentive package', result: 'Passed 13–3' },
      { tag: 'Labor', bill: 'Bill 250220', date: 'Mar 2026', vote: 'yes',
        title: 'Prevailing wage requirement — all city-funded construction over $500k', result: 'Passed 13–4' },
    ],
    upcoming_events: [
      { day: 10, month: 'Jul', title: 'City Council session',
        location: 'City Hall · Room 400 · 10am', tag: 'Public welcome', tag_color: 'green' },
      { day: 22, month: 'Jul', title: 'Majority Leader office hours',
        location: 'City Hall · Room 407 · 1pm–3pm', tag: 'By appointment', tag_color: 'amber' },
    ],
    extra_data: {
      'instagram_url' => 'https://www.instagram.com/kgrichardsonphl/',
      'news_items' => [
        { 'url' => 'https://whyy.org/articles/kg-richardson-majority-leader-2026-agenda/', 'date' => '2026-01-10',
          'title' => 'New Majority Leader Richardson Outlines 2026 Council Agenda — Housing and Jobs Lead', 'source' => 'WHYY' },
        { 'url' => 'https://billypenn.com/2026/03/30/kg-richardson-prevailing-wage-labor-coalition/', 'date' => '2026-03-30',
          'title' => 'Richardson Helps Build Labor Coalition Behind Prevailing Wage Expansion', 'source' => 'Billy Penn' },
        { 'url' => 'https://www.phila.gov/2026-06-10-majority-leader-budget-passage/', 'date' => '2026-06-10',
          'title' => 'Majority Leader Richardson on FY2027 Budget: "A Budget That Invests in People"', 'source' => 'City of Philadelphia' },
      ],
      'sponsored_bills' => [
        { 'bill_number' => '250500', 'title' => 'Affordable Housing Trust Fund Capitalization Act',
          'status' => 'Signed into law', 'status_code' => 'law',
          'summary' => "Directs 1% of the city's real estate transfer tax receipts into the Philadelphia Housing Trust Fund, providing an estimated $8–12M annually for affordable housing construction and preservation.",
          'note' => "Richardson called this \"the most direct investment in affordable housing the council has made in a generation.\"",
          'introduced_date' => '2025-10-15', 'legistar_url' => 'https://phila.legistar.com' },
        { 'bill_number' => '250620', 'title' => 'Citywide Anti-Displacement Strategy Resolution',
          'status' => 'Adopted', 'status_code' => 'law',
          'summary' => "A non-binding resolution directing the city's Office of Housing and Community Development to develop a Citywide Anti-Displacement Strategy within 18 months, including tenant protections, homeowner assistance, and small business preservation.",
          'note' => "Passed 16–1. The lone dissent was Councilmember O'Neill.",
          'introduced_date' => '2026-02-15', 'legistar_url' => 'https://phila.legistar.com' },
      ],
    },
  },

  'mdriscoll-phl-d6' => {
    recent_votes: [
      { tag: 'Streets', bill: 'Bill 250312', date: 'Apr 2026', vote: 'yes',
        title: 'Neighborhood traffic calming — speed bumps and crosswalk upgrades', result: 'Passed 13–3' },
      { tag: 'Development', bill: 'Bill 250140', date: 'Mar 2026', vote: 'yes',
        title: 'Northeast Philadelphia commercial zone — Roosevelt Blvd corridor revitalization', result: 'Passed 12–5' },
      { tag: 'Budget', bill: 'Bill 250001', date: 'Jun 2026', vote: 'yes',
        title: 'FY 2027 Operating Budget — $6.2B citywide appropriation', result: 'Passed 15–2' },
      { tag: 'Housing', bill: 'Bill 240891', date: 'Jan 2026', vote: 'yes',
        title: 'Anti-deed theft protections — registry and notification requirements', result: 'Passed 15–1' },
    ],
    upcoming_events: [
      { day: 10, month: 'Jul', title: 'City Council session',
        location: 'City Hall · Room 400 · 10am', tag: 'Public welcome', tag_color: 'green' },
      { day: 17, month: 'Jul', title: 'District 6 streets & services listening session',
        location: 'Holmesburg Library · 6:30pm', tag: 'All welcome', tag_color: 'blue' },
    ],
    extra_data: {
      'instagram_url' => 'https://www.instagram.com/driscollphl6/',
      'news_items' => [
        { 'url' => 'https://billypenn.com/2026/03/18/northeast-philly-roosevelt-blvd-revitalization/', 'date' => '2026-03-18',
          'title' => 'Roosevelt Boulevard Gets a Revitalization Plan — Driscoll Calls It "Long Overdue"', 'source' => 'Billy Penn' },
        { 'url' => 'https://whyy.org/articles/northeast-philly-traffic-calming-driscoll/', 'date' => '2026-04-22',
          'title' => 'Traffic Calming Comes to Northeast Philly — Three D6 Intersections in First Wave', 'source' => 'WHYY' },
        { 'url' => 'https://www.phila.gov/2026-02-05-inspections-commercial-update/', 'date' => '2026-02-05',
          'title' => 'City Updates Commercial Inspection Procedures — Driscoll Pushed for Faster Turnaround', 'source' => 'City of Philadelphia' },
      ],
      'sponsored_bills' => [
        { 'bill_number' => '250140', 'title' => 'Northeast Philadelphia Commercial Corridor Revitalization Act',
          'status' => 'Signed into law', 'status_code' => 'law',
          'summary' => 'Establishes a dedicated Northeast Philadelphia Commercial Revitalization Fund of $3.5M, targeting storefront improvements, business attraction grants, and public realm upgrades along the Roosevelt Boulevard, Frankford Ave, and Holmesburg Ave corridors.',
          'note' => 'The first comprehensive commercial corridor investment in District 6 in over a decade.',
          'introduced_date' => '2025-08-10', 'legistar_url' => 'https://phila.legistar.com' },
        { 'bill_number' => '250408', 'title' => 'L&I Commercial Inspection Turnaround Act',
          'status' => 'Signed into law', 'status_code' => 'law',
          'summary' => 'Mandates that the Department of Licenses & Inspections complete commercial property inspections within 15 business days of application, with penalty fee refunds if the timeline is missed. Creates a public tracking dashboard.',
          'note' => 'Driscoll introduced the bill after hearing from over 60 small business owners in D6 about multi-month inspection delays.',
          'introduced_date' => '2025-12-01', 'legistar_url' => 'https://phila.legistar.com' },
      ],
    },
  },

  'nahmad-phl-al' => {
    recent_votes: [
      { tag: 'Environment', bill: 'Bill 250295', date: 'Apr 2026', vote: 'yes',
        title: 'Urban tree canopy preservation — 20% canopy target by 2030', result: 'Passed 14–2' },
      { tag: 'Workers', bill: 'Bill 250390', date: 'May 2026', vote: 'yes',
        title: 'Domestic workers bill of rights — overtime, notice, and day-off protections', result: 'Passed 14–3' },
      { tag: 'Budget', bill: 'Bill 250001', date: 'Jun 2026', vote: 'yes',
        title: 'FY 2027 Operating Budget — $6.2B citywide appropriation', result: 'Passed 15–2' },
      { tag: 'Health', bill: 'Bill 250275', date: 'Apr 2026', vote: 'yes',
        title: 'Reproductive health access fund — city-funded clinic support', result: 'Passed 13–4' },
    ],
    upcoming_events: [
      { day: 10, month: 'Jul', title: 'City Council session',
        location: 'City Hall · Room 400 · 10am', tag: 'Public welcome', tag_color: 'green' },
      { day: 19, month: 'Jul', title: 'Environmental justice town hall',
        location: 'Neighborhood Gardens Trust · 5pm', tag: 'Free · All welcome', tag_color: 'green' },
    ],
    extra_data: {
      'instagram_url' => 'https://www.instagram.com/ninaahmadphl/',
      'news_items' => [
        { 'url' => 'https://whyy.org/articles/nina-ahmad-reproductive-health-fund-2026/', 'date' => '2026-04-18',
          'title' => "Reproductive Health Access Fund Passes City Council — Ahmad Led the Push", 'source' => 'WHYY' },
        { 'url' => 'https://billypenn.com/2026/05/20/domestic-workers-bill-of-rights-philadelphia/', 'date' => '2026-05-20',
          'title' => 'Philadelphia Domestic Workers Bill of Rights Signed Into Law', 'source' => 'Billy Penn' },
        { 'url' => 'https://www.phila.gov/2026-04-05-environmental-justice-tree-canopy/', 'date' => '2026-04-05',
          'title' => 'City Sets 2030 Tree Canopy Goal — Ahmad Tied It to Environmental Justice Framework', 'source' => 'City of Philadelphia' },
      ],
      'sponsored_bills' => [
        { 'bill_number' => '250275', 'title' => 'Reproductive Health Access and Support Fund',
          'status' => 'Signed into law', 'status_code' => 'law',
          'summary' => 'Appropriates $2M to support reproductive health clinics operating in Philadelphia, with priority grants for facilities serving Medicaid patients and uninsured residents. Created in response to post-Dobbs service gaps.',
          'note' => "Ahmad called it \"a city acting where the state has failed its residents.\"",
          'introduced_date' => '2025-09-10', 'legistar_url' => 'https://phila.legistar.com' },
        { 'bill_number' => '250485', 'title' => 'Immigrant Community Legal Defense Fund',
          'status' => 'Signed into law', 'status_code' => 'law',
          'summary' => "Establishes a $1.5M legal defense fund for Philadelphia immigrants facing deportation proceedings, administered through the Mayor's Office of Immigrant Affairs. Prioritizes families with U.S.-born children and long-term residents.",
          'note' => 'Ahmad co-led this effort with Councilmember Lozada. Signed by Mayor Parker in June 2026.',
          'introduced_date' => '2025-11-20', 'legistar_url' => 'https://phila.legistar.com' },
      ],
    },
  },

  'norourke-phl-al' => {
    recent_votes: [
      { tag: 'Police', bill: 'Bill 250180', date: 'Mar 2026', vote: 'yes',
        title: 'Body camera footage public release — 30-day disclosure mandate', result: 'Passed 11–6' },
      { tag: 'Housing', bill: 'Bill 250530', date: 'May 2026', vote: 'yes',
        title: 'Tenant right-to-counsel expansion — all eviction proceedings in city courts', result: 'Passed 13–4' },
      { tag: 'Budget', bill: 'Bill 250001', date: 'Jun 2026', vote: 'yes',
        title: 'FY 2027 Operating Budget — $6.2B citywide appropriation', result: 'Passed 15–2' },
      { tag: 'Infrastructure', bill: 'Bill 250312', date: 'Apr 2026', vote: 'yes',
        title: 'Neighborhood traffic calming — speed bumps and crosswalk upgrades', result: 'Passed 13–3' },
    ],
    upcoming_events: [
      { day: 10, month: 'Jul', title: 'City Council session',
        location: 'City Hall · Room 400 · 10am', tag: 'Public welcome', tag_color: 'green' },
      { day: 18, month: 'Jul', title: 'Housing rights clinic — At-Large office',
        location: 'Community Legal Services · 10am–2pm', tag: 'Free legal advice', tag_color: 'amber' },
    ],
    extra_data: {
      'instagram_url' => 'https://www.instagram.com/nicolasorourkephl/',
      'news_items' => [
        { 'url' => 'https://whyy.org/articles/tenant-right-to-counsel-expansion-orourke-2026/', 'date' => '2026-05-22',
          'title' => "Tenant Right-to-Counsel Expansion Passes — O'Rourke Was a Driving Force", 'source' => 'WHYY' },
        { 'url' => 'https://billypenn.com/2026/03/15/body-camera-footage-disclosure-bill/', 'date' => '2026-03-15',
          'title' => "Philadelphia Body Camera Disclosure Bill Passes — O'Rourke Joined Cross-Party Coalition", 'source' => 'Billy Penn' },
        { 'url' => 'https://www.axios.com/local/philadelphia/2026/01/20/minority-whip-orourke-housing', 'date' => '2026-01-20',
          'title' => "Minority Whip O'Rourke Focuses 2026 Agenda on Housing and Police Accountability", 'source' => 'Axios Philadelphia' },
      ],
      'sponsored_bills' => [
        { 'bill_number' => '250530', 'title' => 'Tenant Right-to-Counsel Universal Access Act',
          'status' => 'Signed into law', 'status_code' => 'law',
          'summary' => "Extends the existing right-to-counsel program to all residential eviction proceedings in Philadelphia Municipal Court, regardless of income. The current program covers only tenants at or below 200% of the federal poverty line.",
          'note' => "Philadelphia is now the first city in the country to guarantee universal counsel in eviction proceedings. O'Rourke co-led with Richardson.",
          'introduced_date' => '2025-12-10', 'legistar_url' => 'https://phila.legistar.com' },
        { 'bill_number' => '250640', 'title' => 'Housing Stability Emergency Fund',
          'status' => 'Introduced', 'status_code' => 'introduced',
          'summary' => 'Would create a $5M emergency fund to provide one-time rental assistance for tenants facing eviction due to arrears accumulated during declared city emergencies (weather events, infrastructure failures, health crises).',
          'note' => 'Introduced in response to the 2025 winter flooding that displaced 400+ South Philly residents.',
          'introduced_date' => '2026-02-28', 'legistar_url' => 'https://phila.legistar.com' },
      ],
    },
  },

  'qlozada-phl-d7' => {
    recent_votes: [
      { tag: 'Health', bill: 'Bill 250275', date: 'Apr 2026', vote: 'yes',
        title: 'Reproductive health access fund — city-funded clinic support', result: 'Passed 13–4' },
      { tag: 'Housing', bill: 'Bill 240891', date: 'Jan 2026', vote: 'yes',
        title: 'Anti-deed theft protections — registry and notification requirements', result: 'Passed 15–1' },
      { tag: 'Budget', bill: 'Bill 250001', date: 'Jun 2026', vote: 'yes',
        title: 'FY 2027 Operating Budget — $6.2B citywide appropriation', result: 'Passed 15–2' },
      { tag: 'Immigrants', bill: 'Bill 250485', date: 'Jun 2026', vote: 'yes',
        title: 'Immigrant community legal defense fund — $1.5M appropriation', result: 'Passed 14–3' },
    ],
    upcoming_events: [
      { day: 10, month: 'Jul', title: 'City Council session',
        location: 'City Hall · Room 400 · 10am', tag: 'Public welcome', tag_color: 'green' },
      { day: 17, month: 'Jul', title: 'D7 community health fair',
        location: 'Hunting Park Rec Center · 10am–3pm', tag: 'Free resources', tag_color: 'green' },
      { day: 25, month: 'Jul', title: 'District 7 town hall — housing & immigration',
        location: 'Temple University · 6pm', tag: 'Spanish interpretation available', tag_color: 'blue' },
    ],
    extra_data: {
      'instagram_url' => 'https://www.instagram.com/quetcylozada7/',
      'news_items' => [
        { 'url' => 'https://whyy.org/articles/lozada-immigrant-legal-defense-fund-2026/', 'date' => '2026-06-05',
          'title' => 'Immigrant Legal Defense Fund Passes — Lozada Says "North Philly Families Are Safe Here"', 'source' => 'WHYY' },
        { 'url' => 'https://billypenn.com/2026/04/18/quetcy-lozada-public-health-north-philly/', 'date' => '2026-04-18',
          'title' => "Lozada on the Health Committee: Fighting for North Philly's Most Vulnerable", 'source' => 'Billy Penn' },
        { 'url' => 'https://www.phila.gov/2026-01-22-anti-deed-theft-north-philly/', 'date' => '2026-01-22',
          'title' => "Anti-Deed Theft Protections Signed — Lozada Calls Hunting Park \"Ground Zero\" for the Crisis", 'source' => 'City of Philadelphia' },
      ],
      'sponsored_bills' => [
        { 'bill_number' => '250485', 'title' => 'Immigrant Community Legal Defense Fund',
          'status' => 'Signed into law', 'status_code' => 'law',
          'summary' => "Establishes a $1.5M legal defense fund for Philadelphia immigrants facing deportation proceedings. Prioritizes families with U.S.-born children and long-term residents.",
          'note' => 'Lozada co-led this effort with Councilmember Ahmad. Passed following increased federal immigration enforcement activity in 2025.',
          'introduced_date' => '2025-11-20', 'legistar_url' => 'https://phila.legistar.com' },
        { 'bill_number' => '250370', 'title' => 'Community Health Access and Language Services Act',
          'status' => 'Signed into law', 'status_code' => 'law',
          'summary' => 'Requires all city health centers and contracted community health organizations to provide interpretation services in the top 10 most-spoken languages in their service area, at no cost to the patient.',
          'note' => 'Lozada noted that over 40% of D7 residents speak Spanish as their primary language at home. The bill passed with unanimous support.',
          'introduced_date' => '2025-07-15', 'legistar_url' => 'https://phila.legistar.com' },
      ],
    },
  },

  # msquilla-phl-d1 already has extra_data — just add votes + events
  'msquilla-phl-d1' => {
    recent_votes: [
      { tag: 'Housing', bill: 'Bill 240891', date: 'Jan 2026', vote: 'yes',
        title: 'Anti-deed theft protections — registry and notification requirements', result: 'Passed 15–1' },
      { tag: 'Historic', bill: 'Bill 251030', date: 'Dec 2025', vote: 'yes',
        title: 'Historic Preservation Ordinance — nomination procedure reform', result: 'In committee' },
      { tag: 'Budget', bill: 'Bill 250001', date: 'Jun 2026', vote: 'yes',
        title: 'FY 2027 Operating Budget — $6.2B citywide appropriation', result: 'Passed 15–2' },
      { tag: 'Retail', bill: 'Bill 250733', date: 'Nov 2025', vote: 'yes',
        title: 'Bring Your Own Bag Act — 10-cent paper bag fee on retailers', result: 'Signed into law' },
      { tag: 'Arena', bill: 'Bill 250242', date: 'Mar 2025', vote: 'yes',
        title: "Sixers Arena Repeal — three bills revoking 2024 arena authorization", result: 'Introduced' },
    ],
    upcoming_events: [
      { day: 10, month: 'Jul', title: 'City Council session',
        location: 'City Hall · Room 400 · 10am', tag: 'Public welcome', tag_color: 'green' },
      { day: 15, month: 'Jul', title: 'District 1 office hours',
        location: '1501 S Broad St · 10am–4pm', tag: 'Walk-ins ok', tag_color: 'blue' },
      { day: 22, month: 'Jul', title: 'Market East Advisory Group quarterly meeting',
        location: 'City Hall · Room 400 · 2pm', tag: 'Public testimony open', tag_color: 'amber' },
    ],
  },

}

puts "Updating #{council_data.size} officials..."

council_data.each do |slug, data|
  person = Person.find_by(slug: slug)
  unless person
    puts "  WARN: No Person found for slug=#{slug}"
    next
  end

  updates = {}
  updates[:recent_votes]    = data[:recent_votes]    if data[:recent_votes].present?
  updates[:upcoming_events] = data[:upcoming_events] if data[:upcoming_events].present?

  if data[:extra_data].present?
    merged = (person.extra_data || {}).merge(data[:extra_data])
    updates[:extra_data] = merged
  end

  person.update!(updates)
  puts "  ✓ #{slug}"
end

puts "\nDone. #{council_data.size} officials updated."
