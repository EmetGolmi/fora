puts "Seeding IJDB — National (USA)..."

agency_rows = [
  {
    category:          "current_ongoing",
    title:             "DOD — Overseas Contingency Operations",
    entity_name:       "DOD/OCO",
    description:       "Afghanistan, Iraq, Syria, and all other overseas war funding under the OCO " \
                       "account since 9/11. Includes combat operations, base support, train-and-equip " \
                       "programs, and ATFP (Anti-Terrorism Force Protection) for overseas bases. " \
                       "Does not include VA costs or debt interest on war borrowing.",
    amount_low_cents:  2_300_000_000_000 * 100,
    amount_high_cents: nil,
    confidence:        "documented",
    scope:             "federal",
    date_range_start:  2001,
    date_range_end:    2022,
    source_title:      "Brown University, Costs of War Project (2021)",
    source_url:        "https://watson.brown.edu/costsofwar/",
    display_order:     10,
  },
  {
    category:          "social_psychological",
    title:             "Veterans Administration — Post-9/11 veteran care",
    entity_name:       "VA",
    description:       "Cumulative VA spending attributable to post-9/11 veterans: disability " \
                       "compensation, healthcare, mental health treatment (PTSD, TBI), education " \
                       "benefits (GI Bill), and housing programs. Brown University Costs of War " \
                       "estimates future VA obligations could add another $2T+.",
    amount_low_cents:  2_200_000_000_000 * 100,
    amount_high_cents: nil,
    confidence:        "estimated",
    scope:             "federal",
    date_range_start:  2001,
    date_range_end:    2022,
    source_title:      "Brown University, Costs of War Project (2021)",
    source_url:        "https://watson.brown.edu/costsofwar/",
    display_order:     20,
  },
  {
    category:          "law_enforcement",
    title:             "DHS — Entire department",
    entity_name:       "DHS",
    description:       "Total DHS appropriations since the department was created in 2003. Covers " \
                       "TSA, CBP, ICE, FEMA, Secret Service, Coast Guard, CISA, and all " \
                       "sub-agencies. Created by the Homeland Security Act of 2002 — the largest " \
                       "U.S. government reorganization since the National Security Act of 1947.",
    amount_low_cents:  1_100_000_000_000 * 100,
    amount_high_cents: nil,
    confidence:        "documented",
    scope:             "federal",
    date_range_start:  2003,
    date_range_end:    2022,
    source_title:      "Stimson Center, Counterterrorism Spending (2018)",
    source_url:        "https://www.stimson.org/2018/counterterrorism-spending-protecting-america-while-promoting-efficiencies-and-accountability/",
    display_order:     30,
  },
  {
    category:          "current_ongoing",
    title:             "DOD — Base budget increase above pre-9/11 trajectory",
    entity_name:       "DOD/Base",
    description:       "Pentagon base budget increase above the pre-9/11 defense spending " \
                       "trajectory. Represents the permanent expansion of the defense establishment " \
                       "attributed to the post-9/11 security environment — new commands, new " \
                       "capabilities, new infrastructure — that persisted long after combat operations ended.",
    amount_low_cents:  900_000_000_000 * 100,
    amount_high_cents: nil,
    confidence:        "estimated",
    scope:             "federal",
    date_range_start:  2002,
    date_range_end:    2022,
    source_title:      "Stimson Center, Counterterrorism Spending (2018)",
    source_url:        "https://www.stimson.org/2018/counterterrorism-spending-protecting-america-while-promoting-efficiencies-and-accountability/",
    display_order:     40,
  },
  {
    category:          "opportunity_cost",
    title:             "Debt interest on counter-terrorism spending",
    entity_name:       "Treasury/Interest",
    description:       "The wars and homeland security buildup since 9/11 were funded entirely " \
                       "through deficit spending. Brown University estimates interest on this " \
                       "borrowed money has already exceeded $1T and could reach $6.5T by 2050. " \
                       "This is money spent on past security decisions that crowds out future " \
                       "public investment in perpetuity.",
    amount_low_cents:  1_000_000_000_000 * 100,
    amount_high_cents: nil,
    confidence:        "estimated",
    scope:             "federal",
    date_range_start:  2001,
    date_range_end:    2022,
    source_title:      "Brown University, Costs of War Project (2021)",
    source_url:        "https://watson.brown.edu/costsofwar/",
    display_order:     50,
  },
  {
    category:          "intelligence",
    title:             "Intelligence Community — ODNI / NSA / CIA",
    entity_name:       "IC/ODNI",
    description:       "National Intelligence Program (NIP) and Military Intelligence Program (MIP) " \
                       "spending attributable to counter-terrorism since 9/11. The full budget " \
                       "remained classified until the Snowden disclosures (2013) revealed an " \
                       "annual NIP of ~$52B. Includes NSA SIGINT bulk collection, CIA HUMINT " \
                       "operations, and JTTF intelligence fusion programs.",
    amount_low_cents:  700_000_000_000 * 100,
    amount_high_cents: nil,
    confidence:        "classified",
    scope:             "federal",
    date_range_start:  2001,
    date_range_end:    2022,
    source_title:      "Stimson Center; DNI Annual Threat Assessment",
    source_url:        nil,
    display_order:     60,
  },
  {
    category:          "current_ongoing",
    title:             "State Department / USAID — Anti-terrorism assistance & stabilization",
    entity_name:       "State/USAID",
    description:       "Anti-Terrorism Assistance (ATA) program, Nonproliferation and Disarmament " \
                       "Fund, stabilization and reconstruction funding for Iraq and Afghanistan, " \
                       "counternarcotics programs, and foreign aid flows reoriented toward " \
                       "post-9/11 security priorities. Includes Diplomatic Security Service " \
                       "facility hardening and overseas post security upgrades.",
    amount_low_cents:  138_000_000_000 * 100,
    amount_high_cents: nil,
    confidence:        "documented",
    scope:             "federal",
    date_range_start:  2002,
    date_range_end:    2022,
    source_title:      "Stimson Center, Counterterrorism Spending (2018)",
    source_url:        "https://www.stimson.org/2018/counterterrorism-spending-protecting-america-while-promoting-efficiencies-and-accountability/",
    display_order:     70,
  },
  {
    category:          "law_enforcement",
    title:             "DOJ / FBI — JTTF and domestic counter-terrorism",
    entity_name:       "DOJ/FBI",
    description:       "Joint Terrorism Task Forces (JTTFs), National Security Division, " \
                       "domestic CT investigations, material support prosecutions, " \
                       "radicalization monitoring programs, and FBI budget increases " \
                       "attributable to post-9/11 national security mission expansion. " \
                       "FBI's national security budget share grew from 6% to 40%+ after 9/11.",
    amount_low_cents:  100_000_000_000 * 100,
    amount_high_cents: nil,
    confidence:        "partial",
    scope:             "federal",
    date_range_start:  2001,
    date_range_end:    2022,
    source_title:      "Stimson Center, Counterterrorism Spending (2018)",
    source_url:        "https://www.stimson.org/2018/counterterrorism-spending-protecting-america-while-promoting-efficiencies-and-accountability/",
    display_order:     80,
  },
  {
    category:          "biological",
    title:             "DOE — NNSA Radiological Security and Nuclear Forensics",
    entity_name:       "DOE/NNSA",
    description:       "National Nuclear Security Administration programs targeting radiological " \
                       "terrorism: securing vulnerable nuclear material globally (Global Material " \
                       "Security), dirty bomb detection (Domestic Nuclear Detection Office / DNDO), " \
                       "Nuclear Emergency Support Teams (NEST), and nuclear forensics capabilities " \
                       "to attribute a nuclear detonation to its source.",
    amount_low_cents:  60_000_000_000 * 100,
    amount_high_cents: nil,
    confidence:        "partial",
    scope:             "federal",
    date_range_start:  2002,
    date_range_end:    2022,
    source_title:      "DOE/NNSA Congressional Budget Justifications",
    source_url:        "https://www.energy.gov/nnsa/nnsa-budget",
    display_order:     90,
  },
  {
    category:          "biological",
    title:             "HHS / CDC — Biodefense and public health emergency preparedness",
    entity_name:       "HHS/CDC",
    description:       "BARDA (Biomedical Advanced Research and Development Authority) for " \
                       "medical countermeasures against biological attacks; Strategic National " \
                       "Stockpile (SNS) of vaccines and antibiotics; CDC Public Health Emergency " \
                       "Preparedness grants to state and local health departments; hospital " \
                       "surge capacity programs. Anthrax vaccine procurement alone: $1B+.",
    amount_low_cents:  50_000_000_000 * 100,
    amount_high_cents: nil,
    confidence:        "documented",
    scope:             "federal",
    date_range_start:  2002,
    date_range_end:    2022,
    source_title:      "HHS Biodefense Budget Crosscut; BARDA annual reports",
    source_url:        "https://www.hhs.gov/about/budget/index.html",
    display_order:     100,
  },
  {
    category:          "biological",
    title:             "USPS — Mail security program (BDS, irradiation, Amerithrax)",
    entity_name:       "USPS/Postal Service",
    description:       "Biohazard Detection System deployment at 282 facilities, annual test " \
                       "cartridge supply contracts, congressional and White House mail " \
                       "irradiation program, and Brentwood/Trenton/Hamilton facility " \
                       "decontamination costs following the 2001 anthrax attacks. " \
                       "Ongoing annual consumables run ~$75–100M/year.",
    amount_low_cents:  2_000_000_000 * 100,
    amount_high_cents: nil,
    confidence:        "documented",
    scope:             "federal",
    date_range_start:  2001,
    date_range_end:    nil,
    source_title:      "USPS OIG, Government Executive, Cepheid/Northrop Grumman contract records",
    source_url:        nil,
    display_order:     110,
  },
]

mail_cards = [
  {
    category:          "biological",
    title:             "BDS deployment",
    entity_name:       "USPS",
    description:       "282 large mail processing facilities equipped with 1,373 Biohazard Detection " \
                       "System machines nationwide. Every major USPS Processing and Distribution " \
                       "Center (P&DC) in the country. Deployment completed by 2005.",
    amount_low_cents:  nil,
    amount_high_cents: nil,
    confidence:        "documented",
    scope:             "federal",
    date_range_start:  2002,
    date_range_end:    2005,
    source_title:      "Government Executive, 'Installation of anthrax detectors nears end' (2005)",
    source_url:        nil,
    display_order:     200,
  },
  {
    category:          "biological",
    title:             "Installation cost",
    entity_name:       "USPS",
    description:       "Hardware, Northrop Grumman systems integration, and network infrastructure " \
                       "for full BDS deployment. Initial contract Jan–Oct 2004 alone: $175M. " \
                       "Total hardware and install estimated $375M–$800M across the program.",
    amount_low_cents:  375_000_000 * 100,
    amount_high_cents: 800_000_000 * 100,
    confidence:        "estimated",
    scope:             "federal",
    date_range_start:  2002,
    date_range_end:    2005,
    source_title:      "Northrop Grumman BDS contract awards; GAO postal security reports",
    source_url:        nil,
    display_order:     210,
  },
  {
    category:          "biological",
    title:             "Annual consumables",
    entity_name:       "USPS",
    description:       "Approximately 2 million Cepheid GeneXpert anthrax test cartridges consumed " \
                       "annually across 1,373 machines. 5-year Cepheid supply contract valued at " \
                       "up to $200M. Ongoing cost ~$75–100M per year, every year since 2005.",
    amount_low_cents:  75_000_000 * 100,
    amount_high_cents: 100_000_000 * 100,
    confidence:        "estimated",
    scope:             "federal",
    date_range_start:  2005,
    date_range_end:    nil,
    source_title:      "Cepheid GeneXpert supply contracts; USPS OIG",
    source_url:        nil,
    display_order:     220,
  },
  {
    category:          "biological",
    title:             "How it works — PCR DNA match",
    entity_name:       "USPS",
    description:       "Air is collected from mail sorters hourly. A 90-minute PCR cycle tests for " \
                       "Bacillus anthracis DNA. System auto-shuts the facility if a positive match " \
                       "is detected. Since deployment in 2005: zero confirmed false positives across " \
                       "more than 27 billion mail pieces screened.",
    amount_low_cents:  nil,
    amount_high_cents: nil,
    confidence:        "documented",
    scope:             "federal",
    date_range_start:  2005,
    date_range_end:    nil,
    source_title:      "USPS Biohazard Detection System FAQ",
    source_url:        nil,
    display_order:     230,
  },
  {
    category:          "biological",
    title:             "Mail irradiation",
    entity_name:       "USPS",
    description:       "Congressional and White House mail has been irradiated using electron beam " \
                       "technology since October 2001. Separate DHS/USPS funding stream from BDS. " \
                       "Irradiation facility contracts and ongoing operating costs estimated at $50M+.",
    amount_low_cents:  50_000_000 * 100,
    amount_high_cents: nil,
    confidence:        "estimated",
    scope:             "federal",
    date_range_start:  2001,
    date_range_end:    nil,
    source_title:      "DHS/USPS mail irradiation program records",
    source_url:        nil,
    display_order:     240,
  },
  {
    category:          "biological",
    title:             "Amerithrax cleanup",
    entity_name:       "USPS",
    description:       "The 2001 anthrax letter attacks: 5 deaths, 17 infected. The Brentwood " \
                       "(Washington DC) postal facility alone cost $130M+ to decontaminate and " \
                       "reopen. The FBI Amerithrax investigation ran 7 years at approximately " \
                       "$100M/year. Total cleanup and remediation across all affected sites: ~$1B.",
    amount_low_cents:  1_000_000_000 * 100,
    amount_high_cents: nil,
    confidence:        "estimated",
    scope:             "federal",
    date_range_start:  2001,
    date_range_end:    2008,
    source_title:      "DOJ Amerithrax Investigation Summary; GAO decontamination cost reports",
    source_url:        nil,
    display_order:     250,
  },
]

created = 0
updated = 0
(agency_rows + mail_cards).each do |attrs|
  full_attrs = attrs.merge(city: nil, country: "usa")
  entry = IjdbEntry.find_or_initialize_by(title: full_attrs[:title], city: nil, country: "usa")
  was_new = entry.new_record?
  entry.assign_attributes(full_attrs)
  entry.save!
  was_new ? created += 1 : updated += 1
end

puts "IjdbEntry: #{created} created, #{updated} updated for national (USA)"
