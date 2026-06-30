module OfficialDataHelper
  OFFICIAL_CARD_DATA = {
    "F000479" => {
      photo:       "https://bioguide.congress.gov/bioguide/photo/F/F000479.jpg",
      party:       "Democratic",
      website:     "https://www.fetterman.senate.gov",
      phone:       "(202) 224-4254",
      address:     "152 Russell Senate Office Building, Washington DC 20510",
      party_vote:  68.0,
      missed:      13.9,
      sponsored:   35, cosponsored: 760,
      enacted:     0,  in_committee: 33,
      profile_path: "/mvp/officials/usa/pa/jfetterman",
      bills: [
        { id: "S. 4045", title: "Food and Nutrition Delivery Safety Act of 2026" },
        { id: "S. 3903", title: "Railway Safety Act of 2026" },
        { id: "S. 3796", title: "Ohio River Restoration Program Act of 2026" }
      ]
    },
    "M001243" => {
      photo:       "https://bioguide.congress.gov/bioguide/photo/M/M001243.jpg",
      party:       "Republican",
      website:     "https://www.mccormick.senate.gov",
      phone:       "(202) 224-6324",
      address:     "Washington, DC 20510",
      party_vote:  95.0,
      missed:      2.8,
      sponsored:   40, cosponsored: 170,
      enacted:     2,  in_committee: 38,
      profile_path: "/mvp/officials/usa/pa/dmccormick",
      bills: [
        { id: "S. 4238", title: "Endless Mountains National Heritage Area Act" },
        { id: "S. 3947", title: "REWIRE Act" },
        { id: "S. 3900", title: "Iran Human Rights, Internet Freedom, and Accountability Act of 2026" }
      ]
    },
    "E000296" => {
      photo:       "https://bioguide.congress.gov/bioguide/photo/E/E000296.jpg",
      party:       "Democratic",
      website:     "https://evans.house.gov",
      phone:       "(202) 225-4001",
      address:     "2368 Rayburn House Office Building, Washington DC 20515",
      party_vote:  96.0,
      missed:      14.8,
      sponsored:   10, cosponsored: 350,
      enacted:     0,  in_committee: 10,
      profile_path: "/mvp/officials/usa/pa/devans",
      bills: [
        { id: "HR 7532",   title: "Dr. Constance E. Clayton Post Office designation" },
        { id: "HRES 1071", title: "Recognizing desegregation of Girard College" },
        { id: "HR 2764",   title: "Tax Cut for Workers Act of 2025" }
      ]
    },
    "B001296" => {
      photo:       "https://bioguide.congress.gov/bioguide/photo/B/B001296.jpg",
      party:       "Democratic",
      website:     "https://boyle.house.gov",
      phone:       "(202) 225-6111",
      address:     "1133 Longworth House Office Building, Washington DC 20515",
      party_vote:  97.0,
      missed:      5.2,
      sponsored:   nil, cosponsored: nil,
      enacted:     nil, in_committee: nil,
      profile_path: "/mvp/officials/B001296",
      bills: []
    },
    "nsaval" => {
      photo:       nil,
      party:       "Democratic",
      website:     "https://www.senatornikils.com",
      phone:       "(215) 952-4766",
      address:     "Senate Box 203001, Harrisburg PA 17120",
      party_vote:  nil,
      missed:      nil,
      sponsored:   25, cosponsored: 90,
      enacted:     1,  in_committee: 5,
      profile_path: "/mvp/officials/usa/pa/nsaval",
      bills: [
        { id: "SB 601", title: "Shelter First Act — bans criminalization of homelessness" },
        { id: "SB 4",   title: "Whole-Home Repairs Program — $125M for housing rehabilitation" },
        { id: "SB 900", title: "Tenant Opportunity to Purchase Act" }
      ]
    },
    "bwaxman" => {
      photo:       nil,
      party:       "Democratic",
      website:     "https://www.pahouse.com/waxman",
      phone:       "(215) 463-5269",
      address:     "42B East Wing, Harrisburg PA 17120",
      party_vote:  nil,
      missed:      nil,
      sponsored:   15, cosponsored: 55,
      enacted:     0,  in_committee: 4,
      profile_path: "/mvp/officials/usa/pa/bwaxman",
      bills: [
        { id: "HB 1802", title: "Just Cause Eviction Act" },
        { id: "HB 1420", title: "Fair Workweek Act" },
        { id: "HB 922",  title: "School Infrastructure Repair Fund" }
      ]
    },
    "jgiral" => {
      photo:       "https://www.palegis.us/resources/images/members/300/1980.jpg",
      party:       "Democratic",
      website:     "https://www.pahouse.com/Giral",
      phone:       "(215) 291-5643",
      address:     "3503 B Street, Unit 7, Philadelphia PA 19134",
      party_vote:  nil,
      missed:      nil,
      sponsored:   8, cosponsored: 32,
      enacted:     0, in_committee: 3,
      profile_path: "/mvp/officials/usa/pa/jgiral",
      bills: [
        { id: "HB 877",  title: "Safe Patient Handling Act" },
        { id: "HB 1788", title: "Utility Customer Protection Act" }
      ]
    },
    "ttartaglione" => {
      photo:       "https://www.palegis.us/resources/images/members/300/277.jpg",
      party:       "Democratic",
      website:     "https://senatortartaglione.com",
      phone:       "(215) 533-0440",
      address:     "5321 Oxford Avenue, Philadelphia PA 19124",
      party_vote:  nil,
      missed:      nil,
      sponsored:   22, cosponsored: 85,
      enacted:     0,  in_committee: 5,
      profile_path: "/mvp/officials/usa/pa/ttartaglione",
      bills: [
        { id: "SB 908",  title: "Prevailing Wage Protection Act" },
        { id: "SB 1054", title: "Financial Literacy in Schools Act" }
      ]
    }
  }.freeze

  # Map jurisdiction.name → profile path for executives and city officials
  JURISDICTION_PROFILE_PATHS = {
    "president"            => "/mvp/officials/usa/president",
    "vice_president"       => "/mvp/officials/usa/vp",
    "governor"             => "/mvp/officials/usa/pa/governor",
    "lt_governor"          => "/mvp/officials/usa/pa/lt-governor",
    "mayor"                => "/mvp/officials/usa/pa/philly/mayor",
    "council_president"    => "/mvp/officials/usa/pa/philly/council-president",
    "majority_leader"      => "/mvp/officials/usa/pa/philly/majority-leader",
    "majority_whip"        => "/mvp/officials/usa/pa/philly/majority-whip",
    "minority_leader"      => "/mvp/officials/usa/pa/philly/minority-leader",
    "minority_whip"        => "/mvp/officials/usa/pa/philly/minority-whip",
    "deputy_majority_whip" => "/mvp/officials/usa/pa/philly/deputy-majority-whip",
    "managing_director"    => "/mvp/officials/usa/pa/philly/managing-director",
    "finance_director"     => "/mvp/officials/usa/pa/philly/finance-director",
  }.freeze

  def official_card_data(rep)
    bio = rep.external_ids&.fetch("bioguide_id", nil).to_s
    OFFICIAL_CARD_DATA[bio]
  end

  # Returns the dashboard-relative profile path for an official hash from @officials.
  # Falls back through: bioguide CARD_DATA → jurisdiction name map → city_council district.
  def official_profile_path(o)
    bio      = o.dig(:jurisdiction, :bioguide_id).to_s
    jur_name = o.dig(:jurisdiction, :name).to_s
    district = o.dig(:jurisdiction, :district).to_s

    return OFFICIAL_CARD_DATA[bio][:profile_path] if OFFICIAL_CARD_DATA[bio]&.key?(:profile_path)
    return JURISDICTION_PROFILE_PATHS[jur_name]   if JURISDICTION_PROFILE_PATHS[jur_name]

    if jur_name == "city_council" && district.present?
      "/mvp/officials/usa/pa/philly/district-#{district}"
    end
  end
end
