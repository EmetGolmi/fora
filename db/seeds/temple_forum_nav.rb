$stdout.sync = true
puts "Temple/Forum nav seed: starting"

# ── WIPE OLD DATA ───────────────────────────────────────────────────────────
TempleSubcategory.delete_all
TempleDomain.delete_all
ForumSubcategory.delete_all
ForumDomain.delete_all
puts "Cleared existing temple/forum domain rows"

# ── TEMPLE DOMAINS ──────────────────────────────────────────────────────────
# Eight domains mirroring Market's life-domain structure,
# with subcategories focused on civic guides, rights, and resources.

TEMPLE_DOMAINS = [
  {
    slug: "tpl-your-home", name: "Your Home", icon: "ti-home", position: 1,
    subcategories: [
      { slug: "tenant-rights",        name: "Tenant Rights",          position: 1 },
      { slug: "homeowner-rights",     name: "Homeowner Rights",       position: 2 },
      { slug: "hoa-condo-law",        name: "HOA & Condo Law",        position: 3 },
      { slug: "historic-preservation",name: "Historic Preservation",  position: 4 },
      { slug: "home-safety-guides",   name: "Home Safety Guides",     position: 5 },
      { slug: "environmental-hazards",name: "Environmental Hazards",  position: 6 },
    ]
  },
  {
    slug: "tpl-food-drink", name: "Food & Drink", icon: "ti-salad", position: 2,
    subcategories: [
      { slug: "food-justice",         name: "Food Justice",           position: 1 },
      { slug: "nutrition-guides",     name: "Nutrition Guides",       position: 2 },
      { slug: "local-food-systems",   name: "Local Food Systems",     position: 3 },
      { slug: "restaurant-worker-rights", name: "Restaurant Worker Rights", position: 4 },
      { slug: "food-safety",          name: "Food Safety",            position: 5 },
    ]
  },
  {
    slug: "tpl-health-body", name: "Health & Body", icon: "ti-heart-rate-monitor", position: 3,
    subcategories: [
      { slug: "tpl-hygiene",          name: "Hygiene",                position: 1 },
      { slug: "being-a-patient",       name: "Being a Patient",        position: 2 },
      { slug: "mental-health-resources", name: "Mental Health Resources", position: 3 },
      { slug: "insurance-navigation", name: "Insurance Navigation",   position: 4 },
      { slug: "substance-use-support",name: "Substance Use Support",  position: 5 },
      { slug: "disability-rights",    name: "Disability Rights",      position: 6 },
      { slug: "religion-spirituality",name: "Religion & Spirituality",position: 7 },
    ]
  },
  {
    slug: "tpl-getting-around", name: "Getting Around", icon: "ti-car", position: 4,
    subcategories: [
      { slug: "transit-rights",       name: "Transit Rights",         position: 1 },
      { slug: "safe-streets-guides",  name: "Safe Streets Guides",    position: 2 },
      { slug: "cyclist-pedestrian-rights", name: "Cyclist & Pedestrian Rights", position: 3 },
      { slug: "car-buying-guides",    name: "Car Buying Guides",      position: 4 },
      { slug: "dui-traffic-law",      name: "DUI & Traffic Law",      position: 5 },
    ]
  },
  {
    slug: "tpl-family-care", name: "Family & Care", icon: "ti-heart", position: 5,
    subcategories: [
      { slug: "child-development",    name: "Child Development",      position: 1 },
      { slug: "elder-care-guides",    name: "Elder Care Guides",      position: 2 },
      { slug: "parenting-rights",     name: "Parenting Rights",       position: 3 },
      { slug: "adoption-foster-care", name: "Adoption & Foster Care", position: 4 },
      { slug: "domestic-violence-resources", name: "Domestic Violence Resources", position: 5 },
    ]
  },
  {
    slug: "tpl-style-expression", name: "Style & Expression", icon: "ti-palette", position: 6,
    subcategories: [
      { slug: "fashion-history",      name: "Fashion History",        position: 1 },
      { slug: "cultural-dress",       name: "Cultural Dress",         position: 2 },
      { slug: "body-autonomy",        name: "Body Autonomy",          position: 3 },
      { slug: "art-expression-rights",name: "Art & Expression Rights",position: 4 },
      { slug: "media-literacy",       name: "Media Literacy",         position: 5 },
    ]
  },
  {
    slug: "tpl-learn-grow", name: "Learn & Grow", icon: "ti-books", position: 7,
    subcategories: [
      { slug: "civic-education",      name: "Civic Education",        position: 1 },
      { slug: "financial-literacy",   name: "Financial Literacy",     position: 2 },
      { slug: "formation-guides",     name: "Formation Guides",       position: 3 },
      { slug: "study-skills",         name: "Study Skills",           position: 4 },
      { slug: "critical-thinking",    name: "Critical Thinking",      position: 5 },
    ]
  },
  {
    slug: "tpl-work-livelihood", name: "Work & Livelihood", icon: "ti-briefcase", position: 8,
    subcategories: [
      { slug: "workers-rights",       name: "Workers Rights",         position: 1 },
      { slug: "freelance-contractor", name: "Freelance & Contractor Guides", position: 2 },
      { slug: "business-formation",   name: "Business Formation",     position: 3 },
      { slug: "labor-history",        name: "Labor History",          position: 4 },
      { slug: "union-resources",      name: "Union Resources",        position: 5 },
    ]
  },
].freeze

TEMPLE_DOMAINS.each do |dom|
  record = TempleDomain.find_or_initialize_by(slug: dom[:slug])
  record.assign_attributes(name: dom[:name], icon: dom[:icon], position: dom[:position])
  record.save!
  dom[:subcategories].each do |sub|
    s = TempleSubcategory.find_or_initialize_by(temple_domain: record, slug: sub[:slug])
    s.assign_attributes(name: sub[:name], position: sub[:position])
    s.save!
  end
end

puts "Temple: #{TempleDomain.count} domains, #{TempleSubcategory.count} subcategories"

# ── FORUM DOMAINS ──────────────────────────────────────────────────────────
# Eight domains mirroring Market's life-domain structure,
# with subcategories focused on legislation, policy, and civic programs.
# NOTE: Officials link is a separate hardcoded nav item — not seeded here.

FORUM_DOMAINS = [
  {
    slug: "frm-your-home", name: "Your Home", icon: "ti-home", position: 1,
    subcategories: [
      { slug: "housing-legislation",  name: "Housing Legislation",    position: 1 },
      { slug: "zoning-land-use",      name: "Zoning & Land Use",      position: 2 },
      { slug: "property-tax-bills",   name: "Property Tax Bills",     position: 3 },
      { slug: "code-enforcement",     name: "Code Enforcement",       position: 4 },
      { slug: "affordable-housing",   name: "Affordable Housing Programs", position: 5 },
    ]
  },
  {
    slug: "frm-food-drink", name: "Food & Drink", icon: "ti-salad", position: 2,
    subcategories: [
      { slug: "food-policy-legislation", name: "Food Policy Legislation", position: 1 },
      { slug: "restaurant-licensing", name: "Restaurant Licensing",   position: 2 },
      { slug: "farmers-market-permits", name: "Farmers Market Permits", position: 3 },
      { slug: "urban-agriculture-bills", name: "Urban Agriculture Bills", position: 4 },
    ]
  },
  {
    slug: "frm-health-body", name: "Health & Body", icon: "ti-heart-rate-monitor", position: 3,
    subcategories: [
      { slug: "healthcare-legislation", name: "Healthcare Legislation", position: 1 },
      { slug: "medicaid-medicare-bills", name: "Medicaid & Medicare Bills", position: 2 },
      { slug: "public-health-ordinances", name: "Public Health Ordinances", position: 3 },
      { slug: "pharmacy-regulations", name: "Pharmacy Regulations",   position: 4 },
    ]
  },
  {
    slug: "frm-getting-around", name: "Getting Around", icon: "ti-car", position: 4,
    subcategories: [
      { slug: "transportation-legislation", name: "Transportation Legislation", position: 1 },
      { slug: "road-bridge-bills",    name: "Road & Bridge Bills",    position: 2 },
      { slug: "transit-funding",      name: "Transit Funding",        position: 3 },
      { slug: "parking-vision-zero",  name: "Parking & Vision Zero Ordinances", position: 4 },
    ]
  },
  {
    slug: "frm-family-care", name: "Family & Care", icon: "ti-heart", position: 5,
    subcategories: [
      { slug: "family-law-legislation", name: "Family Law Legislation", position: 1 },
      { slug: "child-welfare-bills",  name: "Child Welfare Bills",    position: 2 },
      { slug: "elder-care-policy",    name: "Elder Care Policy",      position: 3 },
      { slug: "childcare-subsidy",    name: "Childcare Subsidy Programs", position: 4 },
    ]
  },
  {
    slug: "frm-style-expression", name: "Style & Expression", icon: "ti-palette", position: 6,
    subcategories: [
      { slug: "arts-funding-legislation", name: "Arts Funding Legislation", position: 1 },
      { slug: "cultural-heritage-bills", name: "Cultural Heritage Bills", position: 2 },
      { slug: "copyright-ip-ordinances", name: "Copyright & IP Ordinances", position: 3 },
    ]
  },
  {
    slug: "frm-learn-grow", name: "Learn & Grow", icon: "ti-books", position: 7,
    subcategories: [
      { slug: "education-legislation", name: "Education Legislation", position: 1 },
      { slug: "school-funding-bills", name: "School Funding Bills",   position: 2 },
      { slug: "library-adult-education", name: "Library & Adult Education", position: 3 },
      { slug: "workforce-development", name: "Workforce Development Programs", position: 4 },
    ]
  },
  {
    slug: "frm-work-livelihood", name: "Work & Livelihood", icon: "ti-briefcase", position: 8,
    subcategories: [
      { slug: "labor-legislation",    name: "Labor Legislation",      position: 1 },
      { slug: "minimum-wage-bills",   name: "Minimum Wage Bills",     position: 2 },
      { slug: "workplace-safety-ordinances", name: "Workplace Safety Ordinances", position: 3 },
      { slug: "small-business-policy", name: "Small Business Policy", position: 4 },
    ]
  },
].freeze

FORUM_DOMAINS.each do |dom|
  record = ForumDomain.find_or_initialize_by(slug: dom[:slug])
  record.assign_attributes(name: dom[:name], icon: dom[:icon], position: dom[:position])
  record.save!
  dom[:subcategories].each do |sub|
    s = ForumSubcategory.find_or_initialize_by(forum_domain: record, slug: sub[:slug])
    s.assign_attributes(name: sub[:name], position: sub[:position])
    s.save!
  end
end

puts "Forum: #{ForumDomain.count} domains, #{ForumSubcategory.count} subcategories"
puts "Temple/Forum nav seed: done"
