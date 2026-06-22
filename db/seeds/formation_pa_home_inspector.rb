# db/seeds/formation_pa_home_inspector.rb
# Idempotent — safe to re-run. Uses find_or_create_by on stable keys.
# Run standalone: bin/rails runner db/seeds/formation_pa_home_inspector.rb
# Or via:         bin/rails db:seed  (wired in via seeds.rb)

puts "── Formation seed: PA Home Inspector · Single-Member LLC ──"

# ─────────────────────────────────────────────────────────────────────────────
# 1. FORMATION TRACK
# ─────────────────────────────────────────────────────────────────────────────
track = FormationTrack.find_or_create_by!(name: "PA Home Inspector · Single-Member LLC") do |t|
  t.profession      = "Home Inspector"
  t.entity_type     = :single_member_llc
  t.jurisdiction_id = nil   # jurisdictions table does not exist yet
  t.authored_by     = :fora
  t.summary         = "TODO: paste track summary — plain-language overview of the full formation journey for a PA single-member LLC home inspector"
  t.min_cost_cents  = 92_500
  t.max_cost_cents  = 270_000
  t.is_published    = true
  t.version         = 1
end

puts "  FormationTrack: #{track.id} — #{track.name}"

# ─────────────────────────────────────────────────────────────────────────────
# 2. FORMATION STEPS
# Keyed on [track_id, phase, display_order] — stable across re-runs.
# body / cost_range / action_links / save_as are all TODO placeholders.
# ─────────────────────────────────────────────────────────────────────────────
step_defs = [
  # Phase 0 — Choose your structure
  {
    phase:         "Phase 0",
    display_order: 0,
    title:         "Choose your business structure",
    requirement:   :recommended,
    cost_range:    nil,
    naics_code:    nil,
    save_as:       nil,
    action_links:  [],
    community_refined: false,
  },

  # Phase 1 — Form your LLC
  {
    phase:         "Phase 1",
    display_order: 10,
    title:         "File your Certificate of Organization with PA DOS",
    requirement:   :required,
    cost_range:    "$125",
    naics_code:    "541350",
    save_as:       "certificate_of_organization",
    action_links:  [],
    community_refined: false,
  },
  {
    phase:         "Phase 1",
    display_order: 11,
    title:         "Write your single-member operating agreement",
    requirement:   :required,
    cost_range:    "Free",
    naics_code:    nil,
    save_as:       "operating_agreement",
    action_links:  [],
    community_refined: false,
  },
  {
    phase:         "Phase 1",
    display_order: 12,
    title:         "Get your EIN from the IRS",
    requirement:   :required,
    cost_range:    "Free",
    naics_code:    nil,
    save_as:       "ein_confirmation",
    action_links:  [],
    community_refined: false,
  },
  {
    phase:         "Phase 1",
    display_order: 13,
    title:         "Register with myPATH and select NAICS 541350",
    requirement:   :required,
    cost_range:    "Free",
    naics_code:    "541350",
    save_as:       "mypath_registration",
    action_links:  [],
    community_refined: false,
  },

  # Phase 2 — Banking
  {
    phase:         "Phase 2",
    display_order: 20,
    title:         "Open a business checking and savings account",
    requirement:   :required,
    cost_range:    "Varies",
    naics_code:    nil,
    save_as:       "bank_account_confirmation",
    action_links:  [],
    community_refined: false,
  },

  # Phase 3 — PA inspector requirements
  {
    phase:         "Phase 3",
    display_order: 30,
    title:         "Join a qualifying national home inspection association and pass the exam",
    requirement:   :required,
    cost_range:    "$200–$500 + dues",
    naics_code:    nil,
    save_as:       "association_membership",
    action_links:  [],
    community_refined: false,
  },
  {
    phase:         "Phase 3",
    display_order: 31,
    title:         "Get E&O and General Liability insurance",
    requirement:   :required,
    cost_range:    "$800–$2,000/year",
    naics_code:    nil,
    save_as:       "insurance_certificate",
    action_links:  [],
    community_refined: false,
  },
  {
    phase:         "Phase 3",
    display_order: 32,
    title:         "Get PA DEP radon measurement certification",
    requirement:   :optional,
    cost_range:    "$150–$300",
    naics_code:    nil,
    save_as:       "radon_certification",
    action_links:  [],
    community_refined: false,
  },

  # Phase 4 — Online presence
  {
    phase:         "Phase 4",
    display_order: 40,
    title:         "Set up a professional business email address",
    requirement:   :required,
    cost_range:    "$6–$12/month",
    naics_code:    nil,
    save_as:       nil,
    action_links:  [],
    community_refined: false,
  },
  {
    phase:         "Phase 4",
    display_order: 41,
    title:         "Create and verify your Google Business Profile",
    requirement:   :required,
    cost_range:    "Free",
    naics_code:    nil,
    save_as:       nil,
    action_links:  [],
    community_refined: false,
  },

  # Phase 5 — Good standing (recurring)
  {
    phase:         "Phase 5",
    display_order: 50,
    title:         "File your Pennsylvania annual LLC report every September",
    requirement:   :required,
    cost_range:    "$7/year",
    naics_code:    nil,
    save_as:       nil,
    action_links:  [],
    community_refined: false,
  },
  {
    phase:         "Phase 5",
    display_order: 51,
    title:         "Pay quarterly estimated federal and state taxes",
    requirement:   :required,
    cost_range:    "25–30% of revenue",
    naics_code:    nil,
    save_as:       nil,
    action_links:  [],
    community_refined: false,
  },
  {
    phase:         "Phase 5",
    display_order: 52,
    title:         "Renew association membership and insurance annually",
    requirement:   :required,
    cost_range:    "$1,000–$2,500/year",
    naics_code:    nil,
    save_as:       nil,
    action_links:  [],
    community_refined: false,
  },
]

steps_created = 0
steps_existing = 0

step_defs.each do |attrs|
  step = FormationStep.find_or_create_by!(
    formation_track: track,
    phase:           attrs[:phase],
    display_order:   attrs[:display_order]
  ) do |s|
    s.title              = attrs[:title]
    s.requirement        = attrs[:requirement]
    s.cost_range         = attrs[:cost_range]
    s.naics_code         = attrs[:naics_code]
    s.save_as            = attrs[:save_as]
    s.action_links       = attrs[:action_links]
    s.community_refined  = attrs[:community_refined]
    s.body               = "TODO: paste content for \"#{attrs[:title]}\""
    steps_created += 1
  end
  steps_existing += 1 if step.persisted? && step.created_at < 1.second.ago
end

puts "  FormationSteps: #{steps_created} created, #{step_defs.size - steps_created} already existed"

# ─────────────────────────────────────────────────────────────────────────────
# 3. DOCUMENT TEMPLATE
# ─────────────────────────────────────────────────────────────────────────────
doc = DocumentTemplate.find_or_create_by!(name: "PA Single-Member LLC Operating Agreement") do |d|
  d.doc_kind           = :operating_agreement
  d.jurisdiction_id    = nil
  d.authored_by        = :fora
  d.body_template      = "TODO: paste the 14-article operating agreement text with [BRACKET] placeholders"
  d.placeholders       = []
  d.legal_disclaimer   = "For reference only. Not legal advice. Consult a licensed Pennsylvania attorney."
  d.version            = 1
end

puts "  DocumentTemplate: #{doc.id} — #{doc.name}"

# ─────────────────────────────────────────────────────────────────────────────
# 4. DEFINITIONS
# Keyed on [term, context]. Meaning is a TODO placeholder — fill after seeding.
# ─────────────────────────────────────────────────────────────────────────────
definition_defs = [
  { term: "EIN",         context: :financial, meaning: "TODO: Employer Identification Number — plain-language definition" },
  { term: "LLC",         context: :legal,     meaning: "TODO: Limited Liability Company — plain-language definition" },
  { term: "E&O",         context: :legal,     meaning: "TODO: Errors & Omissions insurance — plain-language definition" },
  { term: "GL",          context: :legal,     meaning: "TODO: General Liability insurance — plain-language definition" },
  { term: "NAICS",       context: :financial, meaning: "TODO: North American Industry Classification System — plain-language definition" },
  { term: "CROP",        context: :legal,     meaning: "TODO: Commercial Registered Office Provider — plain-language definition" },
  { term: "DSCB",        context: :legal,     meaning: "TODO: Department of State Corporation Bureau form — plain-language definition" },
  { term: "Schedule C",  context: :financial, meaning: "TODO: IRS Schedule C (Profit or Loss from Business) — plain-language definition" },
  { term: "myPATH",      context: :financial, meaning: "TODO: Pennsylvania's online tax portal — plain-language definition" },
  { term: "NHIE",        context: :legal,     meaning: "TODO: National Home Inspector Examination — plain-language definition" },
  { term: "NRPP",        context: :legal,     meaning: "TODO: National Radon Proficiency Program — plain-language definition" },
  { term: "ASHI",        context: :legal,     meaning: "TODO: American Society of Home Inspectors — plain-language definition" },
  { term: "InterNACHI",  context: :legal,     meaning: "TODO: International Association of Certified Home Inspectors — plain-language definition" },
]

defs_created = 0

definition_defs.each do |d|
  Definition.find_or_create_by!(term: d[:term], context: d[:context]) do |rec|
    rec.plain_meaning = d[:meaning]
    defs_created += 1
  end
end

puts "  Definitions: #{defs_created} created, #{definition_defs.size - defs_created} already existed"
puts "── Done ──"
