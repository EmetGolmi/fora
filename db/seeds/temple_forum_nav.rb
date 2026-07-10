$stdout.sync = true
puts "Temple/Forum nav seed: starting"

# ── TEMPLE DOMAINS ──────────────────────────────────────────────────────────

TEMPLE_DOMAINS = [
  {
    slug: "practice", name: "Practice", icon: "ti-flame", position: 1,
    subcategories: [
      { slug: "meditation",   name: "Meditation",   position: 1 },
      { slug: "prayer",       name: "Prayer",       position: 2 },
      { slug: "fasting",      name: "Fasting",      position: 3 },
      { slug: "pilgrimage",   name: "Pilgrimage",   position: 4 },
    ]
  },
  {
    slug: "study", name: "Study", icon: "ti-books", position: 2,
    subcategories: [
      { slug: "scripture",    name: "Scripture",    position: 1 },
      { slug: "theology",     name: "Theology",     position: 2 },
      { slug: "philosophy",   name: "Philosophy",   position: 3 },
      { slug: "history",      name: "History",      position: 4 },
    ]
  },
  {
    slug: "community", name: "Community", icon: "ti-users", position: 3,
    subcategories: [
      { slug: "congregation", name: "Congregation", position: 1 },
      { slug: "fellowship",   name: "Fellowship",   position: 2 },
      { slug: "outreach",     name: "Outreach",     position: 3 },
      { slug: "charity",      name: "Charity",      position: 4 },
    ]
  },
  {
    slug: "tradition", name: "Tradition", icon: "ti-building-church", position: 4,
    subcategories: [
      { slug: "liturgy",      name: "Liturgy",      position: 1 },
      { slug: "ritual",       name: "Ritual",       position: 2 },
      { slug: "sacraments",   name: "Sacraments",   position: 3 },
      { slug: "calendar",     name: "Calendar",     position: 4 },
    ]
  },
  {
    slug: "ethics", name: "Ethics", icon: "ti-scale", position: 5,
    subcategories: [
      { slug: "moral-theology", name: "Moral Theology", position: 1 },
      { slug: "social-justice", name: "Social Justice", position: 2 },
      { slug: "bioethics",      name: "Bioethics",      position: 3 },
      { slug: "environment",    name: "Environment",    position: 4 },
    ]
  },
  {
    slug: "arts", name: "Arts & Music", icon: "ti-music", position: 6,
    subcategories: [
      { slug: "sacred-music",  name: "Sacred Music",   position: 1 },
      { slug: "iconography",   name: "Iconography",    position: 2 },
      { slug: "architecture",  name: "Architecture",   position: 3 },
      { slug: "poetry",        name: "Poetry",         position: 4 },
    ]
  },
  {
    slug: "healing", name: "Healing", icon: "ti-heart", position: 7,
    subcategories: [
      { slug: "pastoral-care", name: "Pastoral Care",  position: 1 },
      { slug: "grief",         name: "Grief & Loss",   position: 2 },
      { slug: "addiction",     name: "Addiction",      position: 3 },
      { slug: "counseling",    name: "Counseling",     position: 4 },
    ]
  },
  {
    slug: "interfaith", name: "Interfaith", icon: "ti-world", position: 8,
    subcategories: [
      { slug: "dialogue",      name: "Dialogue",       position: 1 },
      { slug: "cooperation",   name: "Cooperation",    position: 2 },
      { slug: "comparative",   name: "Comparative Religion", position: 3 },
      { slug: "peacebuilding", name: "Peacebuilding",  position: 4 },
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

puts "Temple domains seeded: #{TempleDomain.count} domains, #{TempleSubcategory.count} subcategories"

# ── FORUM DOMAINS ──────────────────────────────────────────────────────────

FORUM_DOMAINS = [
  {
    slug: "legislation", name: "Legislation", icon: "ti-building-bank", position: 1,
    subcategories: [
      { slug: "bills",        name: "Bills",          position: 1 },
      { slug: "regulations",  name: "Regulations",    position: 2 },
      { slug: "ballot",       name: "Ballot Issues",  position: 3 },
      { slug: "budgets",      name: "Budgets",        position: 4 },
    ]
  },
  {
    slug: "officials", name: "Officials", icon: "ti-id-badge", position: 2,
    subcategories: [
      { slug: "federal",      name: "Federal",        position: 1 },
      { slug: "state",        name: "State",          position: 2 },
      { slug: "local",        name: "Local",          position: 3 },
      { slug: "judges",       name: "Judges",         position: 4 },
    ]
  },
  {
    slug: "discourse", name: "Discourse", icon: "ti-message", position: 3,
    subcategories: [
      { slug: "debate",       name: "Debate",         position: 1 },
      { slug: "commentary",   name: "Commentary",     position: 2 },
      { slug: "petitions",    name: "Petitions",      position: 3 },
      { slug: "letters",      name: "Letters",        position: 4 },
    ]
  },
  {
    slug: "elections", name: "Elections", icon: "ti-checkbox", position: 4,
    subcategories: [
      { slug: "candidates",   name: "Candidates",     position: 1 },
      { slug: "results",      name: "Results",        position: 2 },
      { slug: "districts",    name: "Districts",      position: 3 },
      { slug: "voter-rights", name: "Voter Rights",   position: 4 },
    ]
  },
  {
    slug: "rights", name: "Rights", icon: "ti-gavel", position: 5,
    subcategories: [
      { slug: "civil-rights",    name: "Civil Rights",    position: 1 },
      { slug: "immigration",     name: "Immigration",     position: 2 },
      { slug: "religious-freedom", name: "Religious Freedom", position: 3 },
      { slug: "press-speech",    name: "Press & Speech",  position: 4 },
    ]
  },
  {
    slug: "security", name: "Security", icon: "ti-shield", position: 6,
    subcategories: [
      { slug: "national",     name: "National Security", position: 1 },
      { slug: "local-safety", name: "Local Safety",   position: 2 },
      { slug: "foreign-policy", name: "Foreign Policy", position: 3 },
      { slug: "intelligence", name: "Intelligence",    position: 4 },
    ]
  },
  {
    slug: "economy", name: "Economy", icon: "ti-chart-bar", position: 7,
    subcategories: [
      { slug: "taxation",     name: "Taxation",       position: 1 },
      { slug: "labor",        name: "Labor",          position: 2 },
      { slug: "trade",        name: "Trade",          position: 3 },
      { slug: "housing",      name: "Housing",        position: 4 },
    ]
  },
  {
    slug: "community-forum", name: "Community", icon: "ti-map-pin", position: 8,
    subcategories: [
      { slug: "neighborhood", name: "Neighborhood",   position: 1 },
      { slug: "education",    name: "Education",      position: 2 },
      { slug: "environment-f", name: "Environment",   position: 3 },
      { slug: "health-policy", name: "Health Policy", position: 4 },
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

puts "Forum domains seeded: #{ForumDomain.count} domains, #{ForumSubcategory.count} subcategories"
puts "Temple/Forum nav seed: done"
