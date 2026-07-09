# db/seeds/formation_pa_home_inspector.rb
# Idempotent — safe to re-run.
# find_or_create_by on stable keys; update! bodies on every run so content can be patched.
# Run standalone: bin/rails runner db/seeds/formation_pa_home_inspector.rb
# Or via:         bin/rails db:seed

puts "── Formation seed: PA Home Inspector · Single-Member LLC ──"

# ─────────────────────────────────────────────────────────────────────────────
# 1. FORMATION TRACK
# ─────────────────────────────────────────────────────────────────────────────
track = FormationTrack.find_or_create_by!(name: "PA Home Inspector · Single-Member LLC") do |t|
  t.profession      = "Home Inspector"
  t.entity_type     = :single_member_llc
  t.jurisdiction_id = nil   # jurisdictions table not yet built
  t.authored_by     = :fora
  t.min_cost_cents  = 92_500
  t.max_cost_cents  = 270_000
  t.is_published    = true
  t.version         = 1
end

track.update!(
  summary: "Forming a single-member LLC as a Pennsylvania home inspector takes about two to three months and costs $925–$2,700 upfront, plus $1,000–$2,500/year in ongoing costs. The steps below walk you through every filing, every credential, and every deadline — in the order you should do them."
)

puts "  FormationTrack: #{track.id} — #{track.name}"

# ─────────────────────────────────────────────────────────────────────────────
# 2. FORMATION STEPS — keyed on [track_id, phase, display_order]
# body and action_links are updated on every run.
# ─────────────────────────────────────────────────────────────────────────────
step_defs = [
  # ── Phase 0 — Choose your structure ────────────────────────────────────
  {
    phase:         "Phase 0",
    display_order: 0,
    title:         "Choose your business structure",
    requirement:   :recommended,
    cost_range:    nil,
    naics_code:    nil,
    save_as:       nil,
    body:          "For most solo service providers in Pennsylvania, a Single-Member LLC is the right choice. It separates your personal assets from your business, costs $125 to form, and is simple to maintain. If you\u2019re going in with a partner or co-owner, you\u2019d form a Multi-Member LLC instead \u2014 but this guide is built for the solo path. A sole proprietorship costs nothing to form, but offers zero liability protection: if a client sues you, your personal savings, home, and car are all at risk. The LLC\u2019s $125 filing fee is the best insurance you can buy.",
    action_links:  [
      { label: "Compare business structures \u2014 SBA.gov", url: "https://www.sba.gov/business-guide/launch-your-business/choose-business-structure" }
    ],
    community_refined: false,
  },

  # ── Phase 1 — Form your LLC ─────────────────────────────────────────────
  {
    phase:         "Phase 1",
    display_order: 10,
    title:         "File your Certificate of Organization with PA DOS",
    requirement:   :required,
    cost_range:    "$125",
    naics_code:    "541350",
    save_as:       "certificate_of_organization",
    body:          "Go to corporations.pa.gov and file a Domestic Limited Liability Company. Your name must end in \u201CLLC\u201D or \u201CL.L.C.\u201D \u2014 check availability first, then fill out the form and pay the $125 filing fee by credit card. The whole thing takes about 15 minutes online. Approval arrives in roughly one business day. Download and print your Certificate of Organization the moment it\u2019s available \u2014 your bank will want to see it in Phase 2. Same-day processing is available for an extra $100 if you submit before 10 a.m.",
    action_links:  [
      { label: "Check name availability \u2014 PA DOS CorpSearch", url: "https://apps.dos.pa.gov/CorpSearch" },
      { label: "File your LLC \u2014 corporations.pa.gov", url: "https://www.corporations.pa.gov" }
    ],
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
    body:          "Don\u2019t let the name intimidate you. For a one-person LLC, an operating agreement is a short document that says: this is my company, I own it, I run it, profits come to me. Pennsylvania doesn\u2019t legally require it \u2014 but your bank will want to see it, and it\u2019s proof that your LLC is a real, separate entity from you personally. Search for a free Pennsylvania single-member LLC operating agreement template, fill in your name, LLC name, address, and formation date, then sign and date it. Keep a digital copy and a printed copy.",
    action_links:  [
      { label: "Search: \u201CPennsylvania single-member LLC operating agreement free template\u201D", url: nil }
    ],
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
    body:          "Once your LLC Certificate is approved, head to the IRS website to get your Employer Identification Number \u2014 the business equivalent of a Social Security number. You\u2019ll use it to open your bank account, file taxes, and put on invoices. The IRS gives these out free and instantly online. Select Limited Liability Company \u2192 Sole Member. The whole thing takes about 10 minutes. Your EIN appears on screen at the very end \u2014 screenshot it, print it, save it. You cannot retrieve it from the portal once you close the tab. If you lose it, you\u2019ll need to call the IRS Business line.",
    action_links:  [
      { label: "Apply for an EIN \u2014 IRS.gov (free, instant)", url: "https://www.irs.gov/businesses/small-businesses-self-employed/apply-for-an-employer-identification-number-ein-online" }
    ],
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
    body:          "Pennsylvania requires business owners to register through myPATH, the state\u2019s online tax portal. During registration you\u2019ll select your NAICS code. For home inspection services, the correct code is 541350 \u2014 Building Inspection Services. This registration establishes your account for paying state income taxes and any applicable local business taxes. You\u2019ll need your EIN and Certificate of Organization ready.",
    action_links:  [
      { label: "myPATH \u2014 Pennsylvania tax registration portal", url: "https://mypath.pa.gov" }
    ],
    community_refined: false,
  },

  # ── Phase 2 — Banking ───────────────────────────────────────────────────
  {
    phase:         "Phase 2",
    display_order: 20,
    title:         "Open a business checking and savings account",
    requirement:   :required,
    cost_range:    "Varies",
    naics_code:    nil,
    save_as:       "bank_account_confirmation",
    body:          "Here\u2019s the single most important financial rule for a new business owner: keep your money completely separate. Every dollar a client pays you goes into the business account. Every business expense comes out of it. Your personal account never touches business money. This isn\u2019t just good practice \u2014 it\u2019s what preserves your LLC\u2019s legal protection. If you ever got sued and your personal and business money were mixed, a court could decide your LLC was never really separate from you, and you\u2019d lose the liability shield you paid $125 to create.\n\nOpen both a checking account (for daily transactions) and a savings account (your tax piggy bank \u2014 move 25\u201330% of every payment straight in). Bring your Certificate of Organization, EIN letter, Operating Agreement, and a government-issued photo ID. Many banks also require an Authorized Resolution \u2014 a short letter stating you\u2019re the manager \u2014 ask if they have their own template.\n\nCredit unions typically charge lower monthly fees on business accounts than traditional banks.",
    action_links:  [
      { label: "FDIC BankFind \u2014 local banks and credit unions", url: "https://banks.data.fdic.gov/docs/" }
    ],
    community_refined: false,
  },

  # ── Phase 3 — PA Inspector Requirements ────────────────────────────────
  {
    phase:         "Phase 3",
    display_order: 30,
    title:         "Join a qualifying national home inspection association and pass the exam",
    requirement:   :required,
    cost_range:    "$200\u2013$500 + dues",
    naics_code:    nil,
    save_as:       "association_membership",
    body:          "Pennsylvania doesn\u2019t issue a state home inspector license \u2014 but that doesn\u2019t mean you can just start inspecting. The law requires you to be a full member in good standing of a recognized national association before you take a paid job. The two main ones are InterNACHI and ASHI. InterNACHI is generally the faster, more affordable path: they offer free online training and their own exam for members. Either way, full membership requires completing an accredited inspection course, passing an exam (the National Home Inspector Exam runs ~$225 per attempt), and logging 100 field inspections. Ride-alongs with a licensed inspector count. Plan this phase over months, not days.",
    action_links:  [
      { label: "InterNACHI \u2014 International Association of Certified Home Inspectors", url: "https://www.nachi.org" },
      { label: "ASHI \u2014 American Society of Home Inspectors", url: "https://www.homeinspector.org" }
    ],
    community_refined: false,
  },
  {
    phase:         "Phase 3",
    display_order: 31,
    title:         "Get E&O and General Liability insurance",
    requirement:   :required,
    cost_range:    "$800\u2013$2,000/year",
    naics_code:    nil,
    save_as:       "insurance_certificate",
    body:          "This one isn\u2019t optional \u2014 Pennsylvania law requires it, and you\u2019d want it anyway. Errors & Omissions (E&O) covers you if a client claims you missed something during an inspection. General Liability (GL) covers you if something goes wrong physically on-site. PA minimums: $100,000 per occurrence / $500,000 aggregate, deductible no more than $2,500. Your association will have insurance programs built for home inspectors \u2014 start there. Get a certificate of insurance when you\u2019re covered: real estate agents will ask for it before they refer you. Don\u2019t let cost scare you off higher coverage tiers \u2014 one unhappy client with an attorney can exceed minimums quickly.",
    action_links:  [
      { label: "InterNACHI member insurance programs", url: "https://www.nachi.org/insurance" }
    ],
    community_refined: false,
  },
  {
    phase:         "Phase 3",
    display_order: 32,
    title:         "Get PA DEP radon measurement certification (optional but recommended)",
    requirement:   :optional,
    cost_range:    "$150\u2013$300",
    naics_code:    nil,
    save_as:       "radon_certification",
    body:          "Central Pennsylvania is one of the highest-radon regions in the country. Clients will ask. Real estate agents will refer you more readily if you can offer radon testing. And it adds $100\u2013$200 per inspection. Pennsylvania DEP requires separate certification before you can legally perform radon measurements. Take an NRPP- or NRSB-approved radon course and pass the exam. InterNACHI offers a free online radon course that\u2019s NRPP-approved \u2014 start there. The exam costs money but pays for itself quickly.",
    action_links:  [
      { label: "PA DEP Radon Certification program", url: "https://www.dep.pa.gov/Business/RadonDivision/Pages/default.aspx" }
    ],
    community_refined: false,
  },

  # ── Phase 4 — Online Presence ───────────────────────────────────────────
  {
    phase:         "Phase 4",
    display_order: 40,
    title:         "Set up a professional business email address",
    requirement:   :required,
    cost_range:    "$6\u2013$12/month",
    naics_code:    nil,
    save_as:       nil,
    body:          "A professional email address (yourname@yourbusiness.com) signals to clients that this is a real, established business \u2014 not someone working out of a personal Gmail. Google Workspace is the most common choice for small businesses: $6\u201312/month gives you a business email address, Google Drive, and Docs. Microsoft 365 (Outlook) is the alternative. Either works. Set this up before you take your first client so all business communications have a professional paper trail from day one.",
    action_links:  [
      { label: "Google Workspace \u2014 business email from $6/month", url: "https://workspace.google.com" },
      { label: "Microsoft 365 Business \u2014 Outlook alternative", url: "https://www.microsoft.com/en-us/microsoft-365/business" }
    ],
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
    body:          "A verified Google Business Profile is the single most important free marketing move you can make. It puts you on Google Maps, shows your business in local search results, and lets clients leave reviews. Claim your listing, add your service area (you\u2019re mobile \u2014 specify the counties you serve), upload a few photos, and respond to every review you receive. The verification process takes about a week \u2014 Google mails a postcard with a code to your business address. Do this as soon as your LLC is formed.",
    action_links:  [
      { label: "Google Business Profile \u2014 free local listing", url: "https://business.google.com" }
    ],
    community_refined: false,
  },

  # ── Phase 5 — Good Standing ─────────────────────────────────────────────
  {
    phase:         "Phase 5",
    display_order: 50,
    title:         "File your Pennsylvania annual LLC report every September",
    requirement:   :required,
    cost_range:    "$7/year",
    naics_code:    nil,
    save_as:       nil,
    body:          "Pennsylvania changed the rules in 2025 \u2014 LLCs must now file an annual report every year by September 30th. It\u2019s not complicated: log in to the state portal, confirm your LLC name, address, and your name as manager, and pay $7. Five minutes. But if you miss it for six months, the state can dissolve your LLC administratively. Set a phone reminder for September 1st every year the moment you read this. You\u2019ll never have to worry about it again.",
    action_links:  [
      { label: "File PA Annual Report \u2014 corporations.pa.gov", url: "https://www.corporations.pa.gov" }
    ],
    community_refined: false,
  },
  {
    phase:         "Phase 5",
    display_order: 51,
    title:         "Pay quarterly estimated federal and state taxes",
    requirement:   :required,
    cost_range:    "25\u201330% of revenue",
    naics_code:    nil,
    save_as:       nil,
    body:          "When you work for yourself, nobody withholds taxes from your paychecks \u2014 because there are no paychecks. Clients pay your LLC, and it\u2019s on you to set aside what you owe and send it in four times a year. This catches a lot of new business owners off guard in April. The fix is simple: every time money comes in, move 25\u201330% into your business savings immediately and leave it there. Federal estimated taxes are due April 15, June 15, September 15, and January 15. Pennsylvania income tax rate is 3.07% \u2014 pay quarterly to PA Dept. of Revenue via myPATH. Your LLC income flows through to your personal federal tax return on Schedule C. Seriously consider a local CPA after your first year \u2014 they\u2019ll save you more than they cost.",
    action_links:  [
      { label: "IRS Form 1040-ES \u2014 Federal estimated tax payments", url: "https://www.irs.gov/forms-pubs/about-form-1040-es" },
      { label: "myPATH \u2014 PA quarterly estimated income tax", url: "https://mypath.pa.gov" }
    ],
    community_refined: false,
  },
  {
    phase:         "Phase 5",
    display_order: 52,
    title:         "Renew association membership and insurance annually",
    requirement:   :required,
    cost_range:    "$1,000\u2013$2,500/year",
    naics_code:    nil,
    save_as:       nil,
    body:          "Your legal right to operate rests on two things staying current: your professional association membership and your insurance. Let either lapse and you\u2019re outside the law. Put both renewal dates in your calendar the day you first sign up. Your association will also require continuing education each year \u2014 treat it as professional development, not busywork. It keeps you sharp, keeps your membership active, and makes you a better inspector.",
    action_links:  [],
    community_refined: false,
  },
]

# ── Upsert steps: find on stable keys, always update content ──────────────
steps_created  = 0
steps_updated  = 0

step_defs.each do |attrs|
  step = FormationStep.find_or_initialize_by(
    formation_track: track,
    phase:           attrs[:phase],
    display_order:   attrs[:display_order]
  )

  is_new = step.new_record?
  step.assign_attributes(
    title:             attrs[:title],
    requirement:       attrs[:requirement],
    cost_range:        attrs[:cost_range],
    naics_code:        attrs[:naics_code],
    save_as:           attrs[:save_as],
    body:              attrs[:body],
    action_links:      attrs[:action_links],
    community_refined: attrs[:community_refined]
  )
  step.save!
  is_new ? steps_created += 1 : steps_updated += 1
end

puts "  FormationSteps: #{steps_created} created, #{steps_updated} updated"

# ─────────────────────────────────────────────────────────────────────────────
# 3. DOCUMENT TEMPLATE
# ─────────────────────────────────────────────────────────────────────────────
doc = DocumentTemplate.find_or_create_by!(name: "PA Single-Member LLC Operating Agreement") do |d|
  d.doc_kind         = :operating_agreement
  d.jurisdiction_id  = nil
  d.authored_by      = :fora
  d.body_template    = "TODO: paste the 14-article operating agreement with [BRACKET] placeholders"
  d.placeholders     = []
  d.legal_disclaimer = "For reference only. Not legal advice. Consult a licensed Pennsylvania attorney."
  d.version          = 1
end

puts "  DocumentTemplate: #{doc.id} — #{doc.name}"

# ─────────────────────────────────────────────────────────────────────────────
# 4. DEFINITIONS — updated on every run
# ─────────────────────────────────────────────────────────────────────────────
def_defs = [
  { term: "EIN",        context: :financial,
    meaning: "Employer Identification Number \u2014 a nine-digit number the IRS assigns to your business, used the way a Social Security Number is used for individuals. Required to open a business bank account, file taxes, and put on invoices." },
  { term: "LLC",        context: :legal,
    meaning: "Limited Liability Company \u2014 a legal structure that separates your personal assets from your business. If a client sues your LLC, your personal savings, home, and car are protected. The LLC itself is liable, not you personally." },
  { term: "E&O",        context: :legal,
    meaning: "Errors & Omissions insurance \u2014 also called professional liability insurance. Covers you if a client claims you made a mistake or missed something in your professional work. Required for PA home inspectors." },
  { term: "GL",         context: :legal,
    meaning: "General Liability insurance \u2014 covers physical accidents or property damage that happen during your work. If a client trips over your equipment or you break something on-site, GL covers it. Required for PA home inspectors." },
  { term: "NAICS",      context: :financial,
    meaning: "North American Industry Classification System \u2014 a standardized code the government uses to classify businesses by type. Home inspection services are NAICS 541350. You\u2019ll need this when registering with PA\u2019s myPATH tax portal." },
  { term: "CROP",       context: :legal,
    meaning: "Commercial Registered Office Provider \u2014 a service that receives official state and legal mail on behalf of your business, keeping your home address out of the public record. Optional for home-based businesses in PA." },
  { term: "DSCB",       context: :legal,
    meaning: "Department of State Corporation Bureau \u2014 the Pennsylvania office that processes LLC filings. When you see a form labeled DSCB-15-8821, that\u2019s the PA Certificate of Organization form for a Domestic LLC." },
  { term: "Schedule C", context: :financial,
    meaning: "IRS Schedule C (Profit or Loss from Business) \u2014 the form you attach to your personal federal tax return (Form 1040) to report your LLC\u2019s income and expenses. Single-member LLCs are taxed as sole proprietorships by default, so your business income flows to Schedule C." },
  { term: "myPATH",     context: :financial,
    meaning: "Pennsylvania\u2019s online tax portal (My Pennsylvania Tax Hub) \u2014 where you register your business, file state income taxes, pay quarterly estimated taxes, and manage PA tax obligations. Free to use." },
  { term: "NHIE",       context: :legal,
    meaning: "National Home Inspector Examination \u2014 a standardized national exam for home inspectors, administered by the Examination Board of Professional Home Inspectors (EBPHI). Costs ~$225 per attempt. Required for full membership in ASHI; accepted by InterNACHI as an alternative to their own exam." },
  { term: "NRPP",       context: :legal,
    meaning: "National Radon Proficiency Program \u2014 accredits radon measurement and mitigation professionals. PA DEP requires NRPP (or NRSB) certification to legally perform radon measurements. InterNACHI\u2019s free online radon course is NRPP-approved." },
  { term: "ASHI",       context: :legal,
    meaning: "American Society of Home Inspectors \u2014 one of the two nationally recognized home inspector associations that satisfy Pennsylvania\u2019s membership requirement. ASHI membership requires passing the NHIE exam and completing 250 inspections." },
  { term: "InterNACHI", context: :legal,
    meaning: "International Association of Certified Home Inspectors \u2014 the other nationally recognized home inspector association accepted by Pennsylvania. Generally the faster, more affordable path for new inspectors: free online training and a free member exam, with full membership after 100 field inspections." },
]

defs_created = 0
defs_updated = 0

def_defs.each do |d|
  rec = Definition.find_or_initialize_by(term: d[:term], context: d[:context])
  is_new = rec.new_record?
  rec.plain_meaning = d[:meaning]
  rec.save!
  is_new ? defs_created += 1 : defs_updated += 1
end

puts "  Definitions: #{defs_created} created, #{defs_updated} updated"
puts "── Done ──"
