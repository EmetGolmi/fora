# db/seeds/market.rb — Market domains, subcategories, providers, temple items
# Idempotent: uses find_or_create_by / find_or_initialize_by throughout.

MARKET_DOMAINS = [
  { name: 'Your home',          slug: 'your-home',        icon: 'ti-home',            position: 0,
    subcategories: [
      'Handyman & repair', 'Roofing', 'Plumbing', 'Electrical', 'Flooring',
      'Painting', 'Carpentry', 'Landscaping', 'Moving', 'Architecture & design',
      'Real estate', 'Pest control', 'Smart home'
    ]
  },
  { name: 'Food & drink',       slug: 'food-drink',       icon: 'ti-salad',           position: 1,
    subcategories: [
      'Restaurants', 'Local producers', 'Home chefs', 'Meal prep', 'Bakers',
      'Farmers markets', 'Food access programs', 'Food scrap & sustainability'
    ]
  },
  { name: 'Health & body',      slug: 'health-body',      icon: 'ti-heart-plus',      position: 2,
    subcategories: [
      'Medical & dental', 'Mental health', 'Fitness & bodywork',
      'Personal care', 'Community health'
    ]
  },
  { name: 'Getting around',     slug: 'getting-around',   icon: 'ti-car',             position: 3,
    subcategories: [
      'Auto repair', 'Tires', 'State inspection', 'Transit & rideshare',
      'Moving & logistics', 'Vehicle services'
    ]
  },
  { name: 'Family & care',      slug: 'family-care',      icon: 'ti-users',           position: 4,
    subcategories: [
      'Childcare', 'Elder care', 'Youth & after-school',
      'Babysitting', 'Pediatricians', 'Pets'
    ]
  },
  { name: 'Style & expression', slug: 'style-expression', icon: 'ti-palette',         position: 5,
    subcategories: [
      'Clothing & tailoring', 'Salon & hair', 'Barber', 'Nail & spa',
      'Faith & community', 'Arts & culture'
    ]
  },
  { name: 'Learn & grow',       slug: 'learn-grow',       icon: 'ti-school',          position: 6,
    subcategories: [
      'Tutoring & coaching', 'Classes & skills',
      'Trades & apprenticeships', 'Cultural experiences'
    ]
  },
  { name: 'Work & livelihood',  slug: 'work-livelihood',  icon: 'ti-briefcase',       position: 7,
    subcategories: [
      'Legal aid', 'Jobs & workforce', 'Business formation',
      'Professional services'
    ]
  }
].freeze

puts "Seeding market domains & subcategories…"

MARKET_DOMAINS.each do |d|
  domain = MarketDomain.find_or_initialize_by(slug: d[:slug])
  domain.assign_attributes(name: d[:name], icon: d[:icon], position: d[:position])
  domain.save!

  d[:subcategories].each_with_index do |sub_name, idx|
    slug = sub_name.downcase.gsub(/[^a-z0-9]+/, '-').gsub(/^-|-$/, '')
    sub = MarketSubcategory.find_or_initialize_by(market_domain: domain, slug: slug)
    sub.assign_attributes(name: sub_name, position: idx)
    sub.save!
  end
end

puts "  → #{MarketDomain.count} domains, #{MarketSubcategory.count} subcategories"

# ── Demo providers — Auto repair ──────────────────────────────────────────────
auto_sub = MarketSubcategory.joins(:market_domain)
                            .find_by!(market_domains: { slug: 'getting-around' }, slug: 'auto-repair')

[
  { name: 'South St. Auto Repair', provider_type: :business,
    latitude: 39.9430, longitude: -75.1590, rating_cache: 4.7,
    address: '1234 South St', neighborhood: 'South Street', city: 'Philadelphia', state: 'PA', zip: '19147' },
  { name: "Tony's Garage", provider_type: :independent,
    latitude: 39.9460, longitude: -75.1520, rating_cache: 4.5,
    address: '567 Passyunk Ave', neighborhood: 'Passyunk Square', city: 'Philadelphia', state: 'PA', zip: '19148' },
  { name: 'Marco Mobile Mechanic', provider_type: :independent,
    is_mobile: true, rating_cache: 4.8,
    service_territory: {
      type: 'Polygon',
      coordinates: [[
        [-75.180, 39.930], [-75.140, 39.930], [-75.140, 39.960],
        [-75.180, 39.960], [-75.180, 39.930]
      ]]
    },
    city: 'Philadelphia', state: 'PA' }
].each do |attrs|
  p = MarketProvider.find_or_initialize_by(market_subcategory: auto_sub, name: attrs[:name])
  p.assign_attributes(attrs.merge(is_active: true))
  p.save!
end

# ── Demo providers — Roofing ─────────────────────────────────────────────────
roof_sub = MarketSubcategory.joins(:market_domain)
                            .find_by!(market_domains: { slug: 'your-home' }, slug: 'roofing')

[
  { name: 'Apex Roofing Co.', provider_type: :business,
    latitude: 39.9430, longitude: -75.1600, rating_cache: 4.8,
    address: '890 Broad St', neighborhood: 'Broad Street', city: 'Philadelphia', state: 'PA', zip: '19146' },
  { name: "Dave's Roofing & Gutters", provider_type: :independent,
    latitude: 39.9450, longitude: -75.1570, rating_cache: 4.6,
    address: '321 Washington Ave', neighborhood: 'Graduate Hospital', city: 'Philadelphia', state: 'PA', zip: '19146' }
].each do |attrs|
  p = MarketProvider.find_or_initialize_by(market_subcategory: roof_sub, name: attrs[:name])
  p.assign_attributes(attrs.merge(is_active: true))
  p.save!
end

puts "  → #{MarketProvider.count} providers"

# ── Temple items — Auto repair ────────────────────────────────────────────────
[
  { item_type: :guide,      title: 'Before you take your car in',
    body: 'Get a written estimate before any work starts. Ask the shop to call you if the final cost will exceed the estimate by more than 10%. Under PA law, shops must return your old parts on request.',
    position: 0 },
  { item_type: :community,  title: 'Philly Car Clinic — free community repair days',
    body: 'Volunteer mechanics host free basic-maintenance clinics at rec centers across Philadelphia. Oil changes, brake checks, and safety inspections for income-qualifying residents.',
    position: 1 }
].each do |attrs|
  item = MarketTempleItem.find_or_initialize_by(market_subcategory: auto_sub, title: attrs[:title])
  item.assign_attributes(attrs.merge(market_domain: nil, is_active: true))
  item.save!
end

# ── Temple items — Roofing ────────────────────────────────────────────────────
[
  { item_type: :guide,   title: 'Before you hire a roofer',
    body: 'Verify contractor registration with the PA Attorney General\'s Office. Get at least three bids. Ask for proof of liability insurance and workers\' comp before signing anything.',
    position: 0 },
  { item_type: :rights,  title: 'PA consumer rights for roofing work',
    body: 'Pennsylvania\'s Home Improvement Consumer Protection Act requires written contracts for jobs over $500. You have a 3-day right to cancel. Contractors must be registered with the state.',
    position: 1 }
].each do |attrs|
  item = MarketTempleItem.find_or_initialize_by(market_subcategory: roof_sub, title: attrs[:title])
  item.assign_attributes(attrs.merge(market_domain: nil, is_active: true))
  item.save!
end

puts "  → #{MarketTempleItem.count} temple items"
puts "Market seed complete."
