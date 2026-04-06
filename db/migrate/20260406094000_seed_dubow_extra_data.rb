class SeedDubowExtraData < ActiveRecord::Migration[8.1]
  def up
    p = Person.find_by(slug: 'rdubow-philly-finance')
    return unless p

    p.update!(
      extra_data: {
        'role_callout' => "Philadelphia's chief financial officer — appointed, not elected. Dubow doesn't decide how money is spent — that's the Mayor and Council. He makes sure there's money to spend. He manages the city's $6.84B budget, keeps the books, issues bonds, manages the pension fund, and tells the Mayor when the numbers don't work. When something gets cut, he's usually the one who identified the problem first.",
        'stats' => [
          { 'value' => '$6.84B', 'label' => 'FY2026 Budget' },
          { 'value' => '18 yrs',  'label' => 'As City CFO' },
          { 'value' => 'A-range', 'label' => 'Bond Rating' }
        ],
        'tenure_highlights' => [
          { 'label' => '3 mayors served' },
          { 'label' => 'Budget managed', 'value' => '$6.84B (FY2026)' },
          { 'label' => 'Credit rating',  'value' => 'A-range — highest in 40+ years' }
        ],
        'budget' => {
          'total'    => '$6.84B',
          'subtitle' => 'Total operating budget approved by City Council · FY2026',
          'segments' => [
            { 'label' => 'Health & Human Services', 'pct' => 38, 'color' => '#1d9e75' },
            { 'label' => 'Public Safety',            'pct' => 22, 'color' => '#378add' },
            { 'label' => 'Education & Libraries',    'pct' => 14, 'color' => '#993556' },
            { 'label' => 'Infrastructure',           'pct' => 12, 'color' => '#ba7517' },
            { 'label' => 'Debt & Pensions',          'pct' => 8,  'color' => '#534ab7' },
            { 'label' => 'General Govt',             'pct' => 6,  'color' => '#888780' }
          ]
        },
        'revenue_sources' => [
          { 'name' => 'Wage & Earnings Tax',   'amount' => '~$2.2B', 'pct_label' => '~33% of budget', 'bar_pct' => 100, 'color' => '#378add',
            'explain' => 'If you work in Philly or live here, a % of every paycheck goes to the city. No other major US city relies on this as much as Philadelphia.' },
          { 'name' => 'Property Tax',          'amount' => '~$800M', 'pct_label' => '~15% of budget', 'bar_pct' => 36,  'color' => '#1d9e75',
            'explain' => '1.3998% of assessed property value. Split between the City and School District. Lower than NYC, Houston, and LA.' },
          { 'name' => 'Business Taxes (BIRT)', 'amount' => '~$700M', 'pct_label' => '~10% of budget', 'bar_pct' => 32,  'color' => '#ba7517',
            'explain' => 'Tax on business revenue and net income. Philly leads all major cities here — a reason businesses cite when choosing not to locate here.' },
          { 'name' => 'Federal & State Grants','amount' => '~$2.8B', 'pct_label' => '~41% of budget', 'bar_pct' => 82,  'color' => '#993556',
            'explain' => 'Medicaid reimbursements, federal housing funds, state education aid. This is the city\'s biggest vulnerability — federal cuts hit here first.' }
        ],
        'does' => [
          { 'title' => 'Proposes and manages the annual budget',
            'sub'   => 'Works with every city department to build the Mayor\'s budget proposal. Monitors spending throughout the year and flags overruns to the Mayor and Council.' },
          { 'title' => 'Borrows money on behalf of the city',
            'sub'   => 'Issues municipal bonds to fund capital projects — buildings, infrastructure, housing. Higher credit rating = lower interest rate = more money for services.' },
          { 'title' => 'Manages the pension fund',
            'sub'   => 'Oversees $7B+ in pension obligations for city workers. Currently at ~68% funded — up from 44.8% in 2016. Full funding frees up $430M/year.' },
          { 'title' => 'Keeps the books for the entire city',
            'sub'   => 'All city financial activity — every contract, payment, and grant — flows through his office. Publishes the Comprehensive Annual Financial Report (CAFR).' },
          { 'title' => 'Monitors federal funding risk',
            'sub'   => 'In 2024, Philly received $2.8B in federal grants. Any reduction hits the city budget immediately. Dubow tracks this and builds reserves.' }
        ],
        'doesnt' => [
          { 'text' => 'Collect your taxes',                     'who' => "That's the Department of Revenue — separate office" },
          { 'text' => 'Decide how the budget is spent',         'who' => 'The Mayor proposes, City Council approves — Dubow executes' },
          { 'text' => "Audit the city's spending",              'who' => "That's the City Controller — independently elected, separate office" },
          { 'text' => 'Manage city contracts and procurement',  'who' => 'Procurement Department — separate, though Finance oversees compliance' }
        ],
        'fiscal_risks' => [
          { 'level' => 'high', 'title' => 'Federal funding cuts',
            'sub'   => '$2.8B in federal grants at risk from Washington policy changes. A $95M reserve has been set aside. Education, medical institutions, and federal jobs generate $1B+ in wage tax revenue alone.' },
          { 'level' => 'high', 'title' => 'ARPA funds exhausted',
            'sub'   => '$1.4B in pandemic federal relief is gone as of end of 2024. Programs funded by ARPA must now come from city tax revenue or be cut.' },
          { 'level' => 'med',  'title' => 'Pension fund not yet fully funded',
            'sub'   => 'At ~68% funded. Annual contributions are a fixed cost. Full funding projected within the decade — at which point $430M/year is freed up.' },
          { 'level' => 'med',  'title' => 'Commercial property tax base erosion',
            'sub'   => 'Remote work has reduced commercial real estate values. Lower assessments = lower property tax revenue from office buildings.' }
        ],
        'career_timeline' => [
          { 'title' => 'Director of Finance',        'sub' => 'Jan 2008 – present · 3 mayors',                  'state' => 'active' },
          { 'title' => 'Exec. Dir., PICA',            'sub' => 'State financial oversight board for Philadelphia', 'state' => 'past' },
          { 'title' => 'CFO, Commonwealth of PA',     'sub' => '2004–2005',                                       'state' => 'past' },
          { 'title' => 'Budget Director, City of Philly', 'sub' => '2000–2004',                                   'state' => 'past' }
        ],
        'credit_ratings' => [
          { 'agency' => "Moody's", 'rating' => 'A2' },
          { 'agency' => 'S&P',     'rating' => 'A'  },
          { 'agency' => 'Fitch',   'rating' => 'A'  }
        ],
        'pension' => {
          'funded_pct'      => 68,
          'from_pct'        => 44.8,
          'from_year'       => 2016,
          'savings_note'    => 'When fully funded, annual contributions drop by $430M — money that could go to services instead. This is the single biggest long-term fiscal improvement Dubow has managed.'
        },
        'tax_comparison' => [
          { 'label' => 'Wage tax reliance',     'value' => '#1 in US',              'red' => true },
          { 'label' => 'Business tax reliance', 'value' => '#1 in US',              'red' => true },
          { 'label' => 'Property tax reliance', 'value' => '2nd lowest major city', 'red' => false }
        ],
        'contact' => {
          'email' => 'rob.dubow@phila.gov',
          'phone' => '(215) 686-6141'
        }
      }
    )
    puts "Updated Dubow extra_data"
  end

  def down
    Person.find_by(slug: 'rdubow-philly-finance')&.update!(extra_data: {})
  end
end
