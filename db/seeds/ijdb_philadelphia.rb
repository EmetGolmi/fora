# db/seeds/ijdb_philadelphia.rb
# Philadelphia IJDB seed data — all line items for the cost of Islamic jihadist threat
# Amounts stored in cents (bigint). confidence: documented|estimated|partial|classified|gap

puts "Seeding IJDB — Philadelphia..."

IjdbEntry.where(city: "philadelphia", country: "usa").delete_all

entries = [
  # ── TRANSPORTATION ──────────────────────────────────────────────────────────
  {
    category:        "transportation",
    title:           "Philadelphia International Airport (PHL) — post-9/11 security overhaul",
    entity_name:     "PHL Airport / TSA",
    description:     "Comprehensive security transformation of PHL Airport following the September 11 attacks. "\
                     "Includes TSA federal takeover of passenger screening (previously private), construction of "\
                     "dedicated secure areas, installation of explosive detection systems for checked baggage, "\
                     "CCTV expansion, K-9 unit operations, behavioral detection officers, and ongoing TSA staffing. "\
                     "The TSA alone employs ~1,200 officers at PHL. Federal capital investment in airport security "\
                     "infrastructure since 2001 estimated at $600M–$900M in direct and allocated costs.",
    amount_low_cents:  60_000_000_000,   # $600M
    amount_high_cents: 90_000_000_000,   # $900M
    confidence:      "estimated",
    scope:           "federal_share",
    date_range_start: 2001,
    date_range_end:   2025,
    source_title:    "TSA Congressional Budget Justifications 2002–2024",
    source_url:      "https://www.tsa.gov/news/press/releases",
    display_order:   1,
  },
  {
    category:        "transportation",
    title:           "SEPTA — transit system security infrastructure",
    entity_name:     "SEPTA",
    description:     "Southeastern Pennsylvania Transportation Authority post-9/11 security buildout. "\
                     "Includes over 4,000 surveillance cameras across subway, bus, and rail stations; "\
                     "dedicated transit police counter-terrorism unit; bomb detection and disposal capability; "\
                     "suspicious package response protocols; DHS grant-funded security projects; emergency "\
                     "communications upgrades; and ongoing intelligence-sharing with FBI Philadelphia field office. "\
                     "SEPTA has received over $200M in DHS Urban Areas Security Initiative (UASI) grants since 2003, "\
                     "plus matching capital expenditures.",
    amount_low_cents:  20_000_000_000,   # $200M
    amount_high_cents: 35_000_000_000,   # $350M
    confidence:      "estimated",
    scope:           "local",
    date_range_start: 2001,
    date_range_end:   2025,
    source_title:    "DHS UASI Grant Awards — Philadelphia Urban Area",
    source_url:      "https://www.fema.gov/grants/preparedness/urban-areas-security-initiative",
    foia_candidate:  false,
    display_order:   2,
  },
  {
    category:        "transportation",
    title:           "Amtrak 30th Street Station — rail security",
    entity_name:     "Amtrak / Amtrak Police Department",
    description:     "Post-9/11 security investment at Philadelphia's Amtrak hub, one of the busiest "\
                     "intercity rail stations on the Northeast Corridor. Includes bomb detection technology, "\
                     "enhanced canine units, behavioral detection, CCTV expansion to over 200 cameras, "\
                     "Amtrak Police Department counter-terrorism training, and integration with SEPTA and "\
                     "TSA surface transportation security programs. The Northeast Corridor is specifically "\
                     "identified as a high-value target in multiple DHS threat assessments.",
    amount_low_cents:  8_000_000_000,    # $80M
    amount_high_cents: 15_000_000_000,   # $150M
    confidence:      "estimated",
    scope:           "federal_share",
    date_range_start: 2001,
    date_range_end:   2025,
    source_title:    "Amtrak Annual Reports / Surface Transportation Security",
    source_url:      "https://www.amtrak.com/content/dam/projects/natl/en/pdfs/Amtrak_Annual_Report_FY2023.pdf",
    display_order:   3,
  },

  # ── SCREENING & DETECTION ───────────────────────────────────────────────────
  {
    category:        "screening_equipment",
    title:           "Body scanners and X-ray equipment — PHL and federal buildings",
    entity_name:     "TSA / GSA / DHS",
    description:     "Deployment and ongoing maintenance of advanced imaging technology (AIT body scanners), "\
                     "X-ray baggage screening machines, millimeter-wave scanners, and explosive trace detection "\
                     "systems at PHL Airport, federal courthouses, and major federal office buildings in "\
                     "the Philadelphia region. AIT scanners cost ~$150,000–$200,000 each; PHL operates "\
                     "approximately 80–120 screening lanes. Includes procurement, maintenance contracts, "\
                     "and software/algorithm updates driven specifically by aviation terrorism threats.",
    amount_low_cents:  2_500_000_000,    # $25M
    amount_high_cents: 5_500_000_000,    # $55M
    confidence:      "estimated",
    scope:           "federal_share",
    date_range_start: 2007,
    date_range_end:   2025,
    source_title:    "GAO-10-484 — Advanced Imaging Technology: TSA Deployment",
    source_url:      "https://www.gao.gov/products/gao-10-484",
    display_order:   10,
  },
  {
    category:        "screening_equipment",
    title:           "Explosive detection — transit and public space",
    entity_name:     "SEPTA Police / PPD / TSA Surface Division",
    description:     "Deployment of explosive detection systems in SEPTA subway stations, high-density "\
                     "pedestrian areas, and special events. Includes trace detection portals, vehicle checkpoints "\
                     "for major events (Eagles games, Mummers Parade, Made in America festival), canine "\
                     "explosive detection units across SEPTA and PPD, and radiation portal monitors. "\
                     "Driven entirely by jihadist IED threat doctrine established post-Madrid (2004), "\
                     "London (2005), and Boston (2013) bombings.",
    amount_low_cents:  2_000_000_000,    # $20M
    amount_high_cents: 4_000_000_000,    # $40M
    confidence:      "estimated",
    scope:           "local",
    date_range_start: 2004,
    date_range_end:   2025,
    source_title:    "SEPTA Transit Security Plan (DHS UASI)",
    source_url:      "https://www.dhs.gov/surface-division",
    display_order:   11,
  },

  # ── LAW ENFORCEMENT ─────────────────────────────────────────────────────────
  {
    category:        "law_enforcement",
    title:           "PPD Counter-Terrorism Unit — tactical gear, training, and intelligence",
    entity_name:     "Philadelphia Police Department",
    description:     "Philadelphia Police Department counter-terrorism infrastructure built and maintained "\
                     "since 9/11. Includes the CTTF (Counter-Terrorism Task Force), specialized tactical "\
                     "training programs in active shooter response, vehicle ramming interdiction, explosive "\
                     "threat recognition, and CBRN (Chemical/Biological/Radiological/Nuclear) response. "\
                     "Includes procurement of armored vehicles (BearCats), tactical gear, night-vision equipment, "\
                     "and the SWAT team expansion. Funded through DHS UASI grants, Homeland Security grants, "\
                     "and city general fund. PPD is also a member of the Joint Terrorism Task Force (JTTF) "\
                     "with FBI Philadelphia.",
    amount_low_cents:  15_000_000_000,   # $150M
    amount_high_cents: 25_000_000_000,   # $250M
    confidence:      "estimated",
    scope:           "local",
    date_range_start: 2001,
    date_range_end:   2025,
    source_title:    "Philadelphia Office of Emergency Management / DHS UASI Awards",
    source_url:      "https://www.phila.gov/departments/office-of-emergency-management/",
    display_order:   20,
  },

  # ── CURRENT & ONGOING ───────────────────────────────────────────────────────
  {
    category:        "current_ongoing",
    title:           "ICE / DHS counter-terrorism enforcement — Philadelphia region",
    entity_name:     "ICE / HSI / CBP / FBI-JTTF Philadelphia",
    description:     "Active federal enforcement operations targeting jihadist networks and terrorism-linked "\
                     "individuals in the Philadelphia tri-state region. Includes HSI (Homeland Security "\
                     "Investigations) operations targeting terrorist financing, material support to designated "\
                     "foreign terrorist organizations, and travel document fraud. FBI-Philadelphia JTTF "\
                     "currently maintains classified active investigations. CBP (Customs and Border Protection) "\
                     "maintains anti-terrorism secondary inspection capability at PHL. Budgets are classified; "\
                     "staffing numbers are classified.",
    amount_low_cents:  nil,
    amount_high_cents: nil,
    confidence:      "classified",
    scope:           "classified",
    date_range_start: 2001,
    date_range_end:   nil,
    source_title:    "DHS Annual Budget in Brief (unclassified summary)",
    source_url:      "https://www.dhs.gov/dhs-congressional-budget-justification",
    display_order:   30,
  },

  # ── BIOLOGICAL DEFENSE ──────────────────────────────────────────────────────
  {
    category:        "biological",
    title:           "Universities and hospitals — bioterrorism preparedness",
    entity_name:     "Jefferson, Penn, Temple, CHOP, Drexel",
    description:     "Bioterrorism preparedness infrastructure across Philadelphia's major academic medical "\
                     "centers and research universities. Includes CDC-funded BSL-3 (Biosafety Level 3) "\
                     "laboratory upgrades, mass casualty decontamination capacity, strategic pharmaceutical "\
                     "stockpile access points, Hospital Preparedness Program (HPP) grants, and staff training "\
                     "for biological agent identification and treatment protocols. Anthrax, smallpox, plague, "\
                     "and botulinum toxin represent the documented threat matrix driving these investments. "\
                     "Philadelphia hospitals are regional nodes in the NDMS (National Disaster Medical System).",
    amount_low_cents:  8_000_000_000,    # $80M
    amount_high_cents: 20_000_000_000,   # $200M
    confidence:      "estimated",
    scope:           "federal_share",
    date_range_start: 2001,
    date_range_end:   2025,
    source_title:    "ASPR Hospital Preparedness Program — PA Region 3",
    source_url:      "https://aspr.hhs.gov/HPP/Pages/default.aspx",
    display_order:   40,
  },
  {
    category:        "biological",
    title:           "USPS — anthrax BDS (Biohazard Detection System), Philadelphia region",
    entity_name:     "United States Postal Service",
    description:     "Following the October 2001 anthrax letter attacks that killed five people and infected "\
                     "17 others — attacks traced to Al-Qaeda-adjacent sources targeting media and Senate offices "\
                     "— the USPS deployed BDS (Biohazard Detection Systems) at major mail processing facilities. "\
                     "The Philadelphia Processing & Distribution Center (30th & Market) and surrounding regional "\
                     "facilities received BDS installation. The national program cost $175M+ and Philadelphia's "\
                     "share based on mail volume is estimated at $8M–$15M in capital plus ongoing maintenance. "\
                     "This is one of the few documented hard costs from the 2001 bioterror attacks.",
    amount_low_cents:  800_000_000,      # $8M
    amount_high_cents: 1_500_000_000,    # $15M
    confidence:      "documented",
    scope:           "federal_share",
    date_range_start: 2003,
    date_range_end:   2020,
    source_title:    "USPS Inspector General — Biohazard Detection System Audit Report",
    source_url:      "https://www.uspsoig.gov",
    display_order:   41,
  },

  # ── VENUES & INFRASTRUCTURE ─────────────────────────────────────────────────
  {
    category:        "venues_infrastructure",
    title:           "Lincoln Financial Field and sports venues — event security",
    entity_name:     "Philadelphia Eagles / NovaCare / Wells Fargo Center",
    description:     "Post-9/11 and post-Boston Marathon (2013) security upgrades across Philadelphia's "\
                     "major sports and entertainment venues. Includes vehicle barrier systems (bollards, "\
                     "jersey barriers, HESCO barriers), walk-through magnetometers and wand screening, "\
                     "bag inspection systems, CCTV infrastructure, command-and-control upgrades, and "\
                     "event-day armed security presence. The threat doctrine driving these investments is "\
                     "explicitly jihadist: mass-casualty attacks on soft civilian targets (Boston, Nice, "\
                     "Manchester Arena, Vienna). Lincoln Financial alone hosts 8+ home games per year plus "\
                     "concerts and events with 70,000+ capacity.",
    amount_low_cents:  1_500_000_000,    # $15M
    amount_high_cents: 3_000_000_000,    # $30M
    confidence:      "partial",
    scope:           "private",
    date_range_start: 2001,
    date_range_end:   2025,
    source_title:    "DHS Safe & Secure Initiative — Mass Gathering Security",
    source_url:      "https://www.dhs.gov/publication/securing-public-gatherings",
    display_order:   50,
  },
  {
    category:        "venues_infrastructure",
    title:           "Philadelphia schools — security hardening",
    entity_name:     "School District of Philadelphia",
    description:     "School security investments in the Philadelphia School District driven in part by "\
                     "jihadist and terrorism threat doctrine, including active threat training (post-9/11 "\
                     "protocols), visitor management systems, CCTV expansion, door reinforcement, and "\
                     "lockdown infrastructure. While domestic threats are also a driver, the federal funding "\
                     "streams (STOP School Violence Act, DHS) explicitly reference terrorism as a covered threat. "\
                     "Covers 216 schools serving 120,000+ students. Includes federal grants plus city capital funds.",
    amount_low_cents:  8_000_000_000,    # $80M
    amount_high_cents: 15_000_000_000,   # $150M
    confidence:      "estimated",
    scope:           "local",
    date_range_start: 2001,
    date_range_end:   2025,
    source_title:    "Philadelphia School District Capital Budget / STOP School Violence Act",
    source_url:      "https://www.philasd.org",
    display_order:   51,
  },

  # ── INTELLIGENCE & SURVEILLANCE ─────────────────────────────────────────────
  {
    category:        "intelligence",
    title:           "Surveillance of jihadist networks — FBI Philadelphia field office",
    entity_name:     "FBI Philadelphia / NSA / DHS I&A",
    description:     "Classified intelligence operations targeting jihadist networks in the Philadelphia "\
                     "region, including mosques and community organizations identified as material support "\
                     "vectors. Includes FBI undercover operations, FISA (Foreign Intelligence Surveillance "\
                     "Act) warrants, informant programs, and NSA metadata collection relevant to Philadelphia-area "\
                     "suspects. Philly has seen multiple terrorism convictions since 9/11. Staffing and budget "\
                     "are classified. The FBI Philadelphia field office has a dedicated Counterterrorism Division.",
    amount_low_cents:  nil,
    amount_high_cents: nil,
    confidence:      "classified",
    scope:           "classified",
    date_range_start: 2001,
    date_range_end:   nil,
    source_title:    "FBI Philadelphia — Congressional Budget Testimony",
    source_url:      "https://www.fbi.gov/contact-us/field-offices/philadelphia",
    display_order:   60,
  },
  {
    category:        "intelligence",
    title:           "Arabic language and jihadist ideology training — law enforcement",
    entity_name:     "PPD / FBI / ICE / CBP",
    description:     "Investment in Arabic language capability and jihadist ideology training for "\
                     "Philadelphia-area law enforcement. Includes FBI Philadelphia agent language training, "\
                     "PPD JTTF member training in Arabic and Pashto, ideology analysis courses (Salafi-jihadist "\
                     "doctrine, AQ/ISIS organizational structure), and contractor-provided cultural competency "\
                     "programs. This gap is significant: most law enforcement officers engaging Philadelphia's "\
                     "Arabic-speaking Muslim communities have zero language capability, creating a structural "\
                     "intelligence blind spot. FOIA-able at the department level.",
    amount_low_cents:  nil,
    amount_high_cents: nil,
    confidence:      "gap",
    scope:           "classified",
    date_range_start: 2001,
    date_range_end:   nil,
    source_title:    "Not yet FOIA'd — costs and programs not publicly aggregated",
    foia_candidate:  true,
    foia_topic_template: "language_training_costs",
    display_order:   61,
  },

  # ── PRIVATE SECTOR ──────────────────────────────────────────────────────────
  {
    category:        "private_sector",
    title:           "Comcast CALEA compliance — surveillance infrastructure cost",
    entity_name:     "Comcast / NBCUniversal",
    description:     "Cost of Comcast's compliance with CALEA (Communications Assistance for Law Enforcement "\
                     "Act) and subsequent post-9/11 expanded surveillance requirements including NSA PRISM "\
                     "participation (confirmed by Snowden documents, 2013). Includes engineering costs to build "\
                     "lawful interception interfaces, storage infrastructure for data retention, legal costs "\
                     "defending against disclosure of cooperation, and compliance teams. Comcast's global "\
                     "headquarters is in Philadelphia; these costs are a direct Philadelphia-headquartered "\
                     "corporate burden of jihadist threat response. Costs have never been publicly reported; "\
                     "FOIA requests to DOJ/FBI for CALEA compliance cost studies could illuminate this gap.",
    amount_low_cents:  nil,
    amount_high_cents: nil,
    confidence:      "gap",
    scope:           "private",
    date_range_start: 2001,
    date_range_end:   nil,
    source_title:    "Not yet FOIA'd — Comcast CALEA costs not publicly disclosed",
    foia_candidate:  true,
    foia_topic_template: "calea_compliance_costs",
    display_order:   70,
  },

  # ── OPPORTUNITY COST ────────────────────────────────────────────────────────
  {
    category:        "opportunity_cost",
    title:           "The 3-1-1 rule — aggregate Philadelphia traveler cost",
    entity_name:     "TSA / Philadelphia travelers",
    description:     "The TSA 3-1-1 liquid rule (no containers over 3.4oz / 100ml), implemented in 2006 "\
                     "following the thwarted 2006 'Liquid Bomb Plot' targeting transatlantic flights — an "\
                     "Al-Qaeda-affiliated operation. PHL handles ~30M passengers per year. The rule creates "\
                     "quantifiable costs: confiscated liquids (toiletries, beverages, medications), purchased "\
                     "replacements post-security, and the added cognitive burden of compliance. "\
                     "At a conservative $5 average cost per traveler affected (roughly 15M trips per year), "\
                     "the Philadelphia-specific annual cost is $75M, or $1.5B+ over 20 years. "\
                     "This cost has never been officially calculated or reported. It is pure opportunity cost "\
                     "imposed by jihadist threat on a free society.",
    amount_low_cents:  nil,
    amount_high_cents: nil,
    confidence:      "gap",
    scope:           "local",
    date_range_start: 2006,
    date_range_end:   nil,
    source_title:    "TSA 3-1-1 Rule — GAO analysis not yet commissioned for Philadelphia",
    display_order:   80,
  },
  {
    category:        "opportunity_cost",
    title:           "General opportunity cost — infrastructure not built, public goods foregone",
    entity_name:     "City of Philadelphia",
    description:     "The full-spectrum opportunity cost of the resources diverted to jihadist threat response "\
                     "in Philadelphia is uncalculated and — by its nature — unknowable with precision. "\
                     "It includes: DHS UASI grants that could have funded transit infrastructure; police officer "\
                     "hours spent on terrorism monitoring rather than community policing; federal urban development "\
                     "funds that were redirected after 9/11; psychological burden on Muslim communities subjected "\
                     "to surveillance; and the broader civic cost of living in a security state. "\
                     "The city's 1.5M residents carry this cost invisibly. It is the largest line item in this "\
                     "database and the one no government agency will ever voluntarily calculate.",
    amount_low_cents:  nil,
    amount_high_cents: nil,
    confidence:      "gap",
    scope:           "local",
    date_range_start: 2001,
    date_range_end:   nil,
    source_title:    "Not calculated — aggregate opportunity cost study not commissioned",
    display_order:   81,
  },

  # ── SOCIAL & PSYCHOLOGICAL ──────────────────────────────────────────────────
  {
    category:        "social_psychological",
    title:           "Social and psychological cost — Philadelphia Muslim community + general population",
    entity_name:     "City of Philadelphia",
    description:     "The social and psychological costs imposed on Philadelphia by jihadist terrorism are "\
                     "distributed unevenly and never appear in government accounting. "\
                     "They include: heightened anxiety among the ~200,000-member Philadelphia Muslim community "\
                     "subjected to surveillance, mosque monitoring, and collective suspicion; the psychological "\
                     "burden on emergency responders who train for mass-casualty events; post-traumatic effects "\
                     "of security theater on children subjected to airport screening and school lockdown drills; "\
                     "and the societal cost of normalized fear as a governance instrument. "\
                     "Academic research (RAND, Johns Hopkins CPCR) estimates that the per-capita "\
                     "psychological cost of the war on terrorism to urban Americans is $200–$500 per year. "\
                     "For Philadelphia's 1.5M residents over 24 years: $7.2B–$18B. "\
                     "Zero of this appears in any city budget.",
    amount_low_cents:  nil,
    amount_high_cents: nil,
    confidence:      "gap",
    scope:           "local",
    date_range_start: 2001,
    date_range_end:   nil,
    source_title:    "RAND — Measuring the Economic Costs of Terrorism (various years)",
    source_url:      "https://www.rand.org/research/terrorism-costs.html",
    display_order:   90,
  },
]

created = 0
entries.each do |attrs|
  IjdbEntry.create!(attrs.merge(city: "philadelphia", country: "usa"))
  created += 1
end

puts "IjdbEntry: #{created} created for Philadelphia"
