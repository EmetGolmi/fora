class RcosController < ApplicationController
  # "19wc" starts with a digit and cannot be a regular Ruby method name,
  # so we use define_method with a string key — Rails dispatches via send().
  define_method("19wc") do
    @rco = {
      name:             "19th Ward Committee RCO",
      initials:         "19",
      slug:             "19wc",
      zip:              "19133",
      neighborhood:     "Fairhill · Kensington",
      expiration_year:  2027,
      ward_committee:   true,
      council_district: 7,

      primary_name:     "Maria Matos",
      primary_email:    "philly19thward@gmail.com",
      primary_phone:    "(267) 236-9857",
      website:          nil,
      website_label:    nil,

      address:               "2122 N Hancock Street, Philadelphia PA 19122",
      meeting_location:      "147 W. Susquehanna Avenue, Philadelphia PA 19122",
      meeting_location_short: "147 W. Susquehanna Ave",

      neighborhood_description:
        "The 19th Ward covers parts of <strong>Fairhill and West Kensington</strong> — the center " \
        "of Philadelphia's Hispanic community, anchored by the <strong>\"El Centro de Oro\"</strong> " \
        "commercial corridor along N. 5th Street. The neighborhood is predominantly Puerto Rican, with " \
        "significant Dominican, Colombian, and Mexican populations, and has one of the highest " \
        "concentrations of Puerto Ricans in the continental United States. Fairhill developed through " \
        "successive immigrant waves — German, then Irish, then Latino — as industries along nearby rail " \
        "lines rose and fell. Today it faces dual pressures: the legacy of disinvestment from decades of " \
        "city neglect, and rising development pressure pushing north from Fishtown and East Kensington. " \
        "Bounded roughly by Germantown Ave, Front Street, Allegheny Ave, and Cumberland Street.",

      ward_explainer:
        "Philadelphia's 66 political wards each elect a ward committee — Democratic and Republican " \
        "committeepersons from every division (precinct). Ward committees are automatically eligible to " \
        "register as RCOs, giving them an official role in zoning decisions even though their primary " \
        "purpose is electoral organizing. The 19th Ward Committee serves this dual function: partisan " \
        "political organizing <em>and</em> neighborhood zoning representation. Residents engaging on " \
        "zoning issues should attend ward committee meetings and can also submit written comments " \
        "directly to the PCPC.",

      stats: [
        { number: "80%+", label: "Latino / Hispanic"       },
        { number: "61%",  label: "Poverty rate · Fairhill" },
        { number: "7th",  label: "Council District"        },
      ],

      issue_tags: [
        "Ward politics",
        "Zoning",
        "Anti-displacement",
        "Housing",
        "Community organizing",
        "Latino civic life",
      ],

      gov_contacts: [
        { icon: "🏛", name: "Quetcy Lozada · City Council, District 7", detail: "(215) 686-3458 · district7@phila.gov"           },
        { icon: "📋", name: "Licenses & Inspections",                    detail: "(215) 686-2463 · Zone: North"                  },
        { icon: "🚔", name: "24th Police District",                      detail: "(215) 686-3240 · N. Broad & Lehigh"            },
        { icon: "🌳", name: "Fairhill Square Park",                      detail: "Parks & Rec · N. 5th & Lehigh Ave"             },
        { icon: "🏗", name: "Philadelphia City Planning Commission",     detail: "RCO Coordinator · (215) 683-4615"             },
      ],
    }
  end

  def nscan
    @rco = {
      name:             "Norris Square Community Action Network",
      initials:         "NS",
      slug:             "nscan",
      zip:              "19133",
      neighborhood:     "West Kensington",
      expiration_year:  2026,
      ward_committee:   false,
      council_district: 7,

      primary_name:     "Nilda L. Pimentel-Perez",
      primary_email:    "contact@nscanphilly.org",
      primary_phone:    "(267) 231-9470",
      website:          "https://nscanphilly.org",
      website_label:    "nscanphilly.org",

      address:               "c/o West Kensington Ministry, 2140 N. Hancock Street, Philadelphia PA 19122",
      meeting_location:      "West Kensington Ministry · 2140 N Hancock Street, Philadelphia PA 19122",
      meeting_location_short: "West Kensington Ministry, 2140 N Hancock",

      neighborhood_description:
        "Norris Square is a predominantly Puerto Rican and Latino neighborhood in lower North " \
        "Philadelphia, built around <strong>Norris Square Park</strong> — \"El Parque de Las " \
        "Ardillas\" — a 5.8-acre community anchor dating to 1848. The neighborhood was abandoned by " \
        "the city in the 1970s after deindustrialization gutted Kensington's factories. Residents, " \
        "led by women's group <strong>Grupo Motivos</strong>, reclaimed six vacant lots and built the " \
        "community gardens that remain today. Now facing development pressure from nearby Fishtown and " \
        "Northern Liberties, NSCAN exists to ensure that residents who rebuilt this neighborhood are " \
        "not displaced from it. Bounded roughly by American Street, Front Street, York Street, and " \
        "Berks Street.",

      ward_explainer: nil,

      stats: [
        { number: "~5,700", label: "Residents"        },
        { number: "80%+",   label: "Latino / Hispanic" },
        { number: "7th",    label: "Council District"  },
      ],

      issue_tags: [
        "Housing",
        "Anti-displacement",
        "Youth programs",
        "Green space",
        "Immigration",
        "Public health",
      ],

      gov_contacts: [
        { icon: "🏛", name: "Quetcy Lozada · City Council, District 7", detail: "(215) 686-3458 · district7@phila.gov"                  },
        { icon: "📋", name: "Licenses & Inspections",                    detail: "(215) 686-2463 · Zone: North"                         },
        { icon: "🚔", name: "24th Police District",                      detail: "(215) 686-3240 · N. Broad & Lehigh"                   },
        { icon: "🌳", name: "Nelson Playground / McVeigh Rec",           detail: "(215) 685-1583 · W Cumberland & N Hancock"            },
        { icon: "🏗", name: "Philadelphia City Planning Commission",     detail: "RCO Coordinator · (215) 683-4615"                    },
      ],
    }
  end

  def epcrossing
    @rco = {
      name: "East Passyunk Crossing Civic Association",
      initials: "EP",
      slug: "epcrossing",
      zip: "19148",
      neighborhood: "East Passyunk",
      expiration_year: 2027,
      ward_committee: false,
      council_district: 2,
      primary_name: "EPCA Board",
      primary_email: "info@eastpassyunk.org",
      primary_phone: nil,
      website: "https://www.eastpassyunk.org",
      website_label: "eastpassyunk.org",
      address: "East Passyunk · Philadelphia PA 19148",
      meeting_location: "Monthly — see eastpassyunk.org for schedule",
      meeting_location_short: "Monthly — see eastpassyunk.org",
      org_type_label: "Civic Association",
      legal_status: "Registered Community Organization",
      mission: "Advocate for responsible development and community vitality along East Passyunk Avenue while preserving the character and safety of the surrounding neighborhood.",
      neighborhood_description:
        "East Passyunk is one of Philadelphia's most celebrated neighborhood commercial corridors — a " \
        "curved stretch of restaurants, boutiques, and row homes radiating out from Passyunk Square Park " \
        "in South Philadelphia. The neighborhood takes its name from a Lenape word for \"low-lying meadow\" " \
        "and was historically home to Italian, Irish, and Polish immigrant communities. Today it is " \
        "widely recognized as one of the city's most vibrant dining and small-business destinations, " \
        "a distinction that has brought both investment and displacement pressure. The East Passyunk " \
        "Crossing Civic Association serves the blocks surrounding the Avenue corridor and the Italian " \
        "Market area, sharing boundaries with Bella Vista to the north and Newbold to the west. " \
        "The RCO has been active on pedestrian safety (Vision Zero corridor designation), " \
        "zoning and development review, historic preservation, and maintaining the neighborhood's " \
        "distinctive street character. Bounded roughly by Washington Ave, Broad Street, Morris Street, " \
        "and 10th Street.",
      stats: [
        { number: "2nd",     label: "Council District" },
        { number: "19148",   label: "ZIP Code"         },
        { number: "Active",  label: "RCO Status"       }
      ],
      issue_tags: [
        "Vision Zero", "Pedestrian safety", "Slow zones", "Zoning",
        "Historic preservation", "East Passyunk Ave", "Small business",
        "Public safety", "Traffic calming", "Parks"
      ],
      gov_contacts: [
        { icon: "🏛", name: "Kenyatta Johnson · City Council, District 2", detail: "(215) 686-3412 · district2@phila.gov" },
        { icon: "📋", name: "Licenses & Inspections",                      detail: "(215) 686-2463 · Zone: South"         },
        { icon: "🚔", name: "3rd Police District",                          detail: "(215) 686-3030 · 11th & Wharton"      },
        { icon: "🌳", name: "Mifflin Square Park",                          detail: "Parks & Rec · 9th & Washington"       },
        { icon: "🏗", name: "Philadelphia City Planning Commission",        detail: "RCO Coordinator · (215) 683-4615"    }
      ]
    }
    render 'rcos/show'
  end

  def fishtown
    @rco = {
      name: "Fishtown Neighbors Association",
      initials: "FN",
      slug: "fishtown",
      zip: "19125",
      neighborhood: "Fishtown",
      expiration_year: 2027,
      ward_committee: false,
      council_district: 1,
      primary_name: "Robert Everett",
      primary_email: "zoning@fishtown.org",
      primary_phone: nil,
      website: "https://www.fishtown.org",
      website_label: "fishtown.org",
      address: "PO Box 3744, Philadelphia, PA 19125",
      meeting_location: "Zoom — Tuesdays at 6:30pm · fishtown.org for RSVP link",
      meeting_location_short: "Zoom — Tuesdays at 6:30pm",
      org_type_label: "Neighborhood Association",
      legal_status: "501(c)(3) Nonprofit · All-volunteer",
      mission: "Connect Fishtown neighbors, preserve Fishtown's unique character, and honor our community's shared vision for its future.",
      neighborhood_description: "Fishtown is one of Philadelphia's most rapidly changing neighborhoods — a former working-class industrial district along the Delaware River that has become a national model of urban gentrification, for better and worse. Named for the shad fishermen who worked the river in the 18th and 19th centuries, the neighborhood was home to Polish, Irish, and Ukrainian factory workers for most of its history. Deindustrialization hollowed it out in the mid-20th century. Since the 2000s, Fishtown has seen extraordinary investment alongside significant displacement pressure, with longtime residents navigating rapidly rising rents alongside an influx of restaurants, bars, and new construction. FNA is one of Philadelphia's most active RCOs, with a zoning committee that reviews dozens of variance applications per year and a verified voter system that gives residents a formal vote on zoning decisions. Bounded roughly by the Delaware River, Frankford Avenue, Lehigh Avenue, and Front Street.",
      committees: [
        { icon: "🏗", name: "Zoning", desc: "Reviews variance applications, holds community zoning meetings via Zoom on Tuesdays at 6:30pm. Residents must register as verified voters to vote on applications. Contact: zoning@fishtown.org" },
        { icon: "🛡", name: "Safety & Planning", desc: "Neighborhood safety, planning issues, and coordination with the 26th Police District." },
        { icon: "🌿", name: "Beautification", desc: "Green spaces, streetscape, and neighborhood appearance projects." },
        { icon: "🎉", name: "Events", desc: "Meet the Neighbors, Music in the Park, Holiday Party, Chili Cookoff, Sidewalk Sale, and Fishtown Neighborhood Scholarship." }
      ],
      stats: [
        { number: "~17K", label: "Residents" },
        { number: "501(c)(3)", label: "Legal status" },
        { number: "1st", label: "Council District" }
      ],
      issue_tags: ["Zoning", "Development", "Nightlife regulation", "Displacement", "Historic preservation", "Transit", "Safety"],
      gov_contacts: [
        { icon: "🏛", name: "Mark Squilla · City Council, District 1", detail: "(215) 686-3458 · district1@phila.gov" },
        { icon: "📋", name: "Licenses & Inspections", detail: "(215) 686-2463 · Zone: North" },
        { icon: "🚔", name: "26th Police District", detail: "(215) 686-3190 · E. Sergeant & Trenton Ave" },
        { icon: "🌳", name: "Fishtown Recreation Center", detail: "(215) 685-9921 · 1202 E Montgomery Ave" },
        { icon: "🏗", name: "Philadelphia City Planning Commission", detail: "RCO Coordinator · (215) 683-4615" }
      ]
    }
    render 'rcos/show'
  end

  def fkabid
    @rco = {
      name: "Fishtown Kensington Area Business Improvement District",
      initials: "FK",
      slug: "fkabid",
      zip: "19122",
      neighborhood: "Fishtown · East Kensington",
      expiration_year: 2026,
      council_district: 1,
      primary_name: "Marc Collazzo",
      primary_email: "marc@fishtownbid.org",
      primary_phone: "(267) 764-3724",
      website: "https://fishtowndistrict.com",
      website_label: "fishtowndistrict.com",
      address: "1509 N Front Street, Philadelphia PA 19122",
      meeting_location: "Zoom — see fishtowndistrict.com for schedule",
      meeting_location_short: "Zoom — see fishtowndistrict.com",
      org_type_label: "Business Improvement District",
      legal_status: "Special Services District · RCO",
      mission: "Support and promote the Fishtown and Kensington commercial corridor through cleaning, safety, beautification, and business development programs.",
      ward_committee: true,
      ward_explainer: "A Business Improvement District (BID) is a defined commercial area where property owners vote to assess themselves an additional fee, used collectively for services the city doesn't provide — cleaning, lighting, marketing, and business support. BIDs are eligible to register as RCOs, giving them formal standing in zoning hearings affecting their corridor. The FKABID RCO represents commercial property interests — it is distinct from the residential FNA that represents residents. Both may be notified on the same zoning application in Fishtown. When evaluating a development, residents should be aware that the BID's position may reflect commercial interests that differ from neighborhood residential interests.",
      neighborhood_description: "The Fishtown Kensington Area Business Improvement District covers the commercial corridors of Frankford Avenue and Girard Avenue through Fishtown and East Kensington — one of the most economically dynamic stretches in Philadelphia. The district runs programming around Clean & Green sanitation services, Safe & Secure safety ambassadors, and Beautification improvements along the corridor. The BID produces a business directory, hosts neighborhood events, and maintains a newsletter for stakeholders and residents. As an RCO, it has formal standing in zoning decisions affecting commercial properties along its service corridor.",
      committees: [
        { icon: "🧹", name: "Clean & Green", desc: "Sanitation, sidewalk cleaning, and green space maintenance along the commercial corridor." },
        { icon: "🛡", name: "Safe & Secure", desc: "Safety ambassadors, coordination with police, and corridor security programs." },
        { icon: "🌿", name: "Beautification", desc: "Streetscape improvements, lighting, and corridor beautification projects." }
      ],
      stats: [
        { number: "BID", label: "Organization type" },
        { number: "2026", label: "RCO active thru" },
        { number: "1st", label: "Council District" }
      ],
      issue_tags: ["Commercial corridor", "Nightlife", "Business development", "Outdoor dining", "Signage", "Streetscape", "Safety"],
      gov_contacts: [
        { icon: "🏛", name: "Mark Squilla · City Council, District 1", detail: "(215) 686-3458 · district1@phila.gov" },
        { icon: "📋", name: "Licenses & Inspections", detail: "(215) 686-2463 · Zone: North" },
        { icon: "🚔", name: "26th Police District", detail: "(215) 686-3190 · E. Sergeant & Trenton Ave" },
        { icon: "🏗", name: "Philadelphia City Planning Commission", detail: "RCO Coordinator · (215) 683-4615" }
      ]
    }
    render 'rcos/show'
  end

  def wgirard
    @rco = {
      name: "West Girard Progress",
      initials: "WG",
      slug: "wgirard",
      zip: "19123",
      neighborhood: "West Girard · Francisville",
      expiration_year: 2027,
      ward_committee: false,
      council_district: 5,
      primary_name: "Barbara Pennock",
      primary_email: "bjchavous@gmail.com",
      primary_phone: nil,
      website: nil,
      website_label: nil,
      address: "719 W. Girard Avenue, Philadelphia PA 19123",
      meeting_location: "719 W. Girard Avenue, Philadelphia PA 19123",
      meeting_location_short: "719 W. Girard Avenue",
      org_type_label: "Neighborhood Organization",
      legal_status: "Registered Community Organization",
      mission: "Advocate for responsible development along the West Girard Avenue corridor while protecting the interests of existing residents and small businesses in Francisville and the surrounding community.",
      neighborhood_description: "West Girard Progress serves the West Girard Avenue corridor and the surrounding Francisville neighborhood — a historically African American community in North Central Philadelphia experiencing significant development pressure as investment spreads north from Fairmount and Brewerytown. Girard Avenue is one of Philadelphia's great east-west commercial boulevards. The West Girard stretch has long served as a neighborhood main street anchored by longtime small businesses, churches, and community institutions. West Girard Progress focuses on ensuring that new development along the corridor serves existing residents rather than displacing them. The corridor sits at the intersection of two powerful forces — the southward spread of North Philadelphia's disinvestment legacy and the northward spread of Center City gentrification — making it one of the city's most important civic battlegrounds for equitable development. Bounded roughly by Broad Street to the east, 10th Street to the west, Fairmount Avenue to the south, and Poplar Street to the north.",
      stats: [
        { number: "5th", label: "Council District" },
        { number: "19123", label: "ZIP Code" },
        { number: "Girard Ave", label: "Primary corridor" }
      ],
      issue_tags: ["Commercial corridor", "Development", "Displacement", "Affordable housing", "Small business", "Community ownership", "Equitable development"],
      gov_contacts: [
        { icon: "🏛", name: "Jeffery Young Jr. · City Council, District 5", detail: "(215) 686-3412 · district5@phila.gov" },
        { icon: "📋", name: "Licenses & Inspections", detail: "(215) 686-2463 · Zone: North Central" },
        { icon: "🚔", name: "22nd Police District", detail: "(215) 686-3220 · 17th & Montgomery Ave" },
        { icon: "🌳", name: "Francisville Recreation Center", detail: "Parks & Rec · 1737 Francis St" },
        { icon: "🏗", name: "Philadelphia City Planning Commission", detail: "RCO Coordinator · (215) 683-4615" }
      ]
    }
    render 'rcos/show'
  end

  def generic
    slug = params[:slug]
    @rco_data = Rails.cache.fetch("rco_slug/#{slug}", expires_in: 24.hours) do
      PhillyRcoService.find_by_slug(slug)
    end
    return render plain: "RCO not found", status: :not_found if @rco_data.nil?
  end

  def ccra
    @rco = {
      name:             "Center City Residents Association",
      initials:         "CC",
      slug:             "ccra",
      zip:              "19103",
      neighborhood:     "Center City",
      expiration_year:  2027,
      ward_committee:   false,
      council_district: 1,

      primary_name:     "CCRA Board",
      primary_email:    "info@ccraonline.org",
      primary_phone:    "(215) 557-9280",
      website:          "https://www.ccraonline.org",
      website_label:    "ccraonline.org",

      address:               "P.O. Box 58460, Philadelphia PA 19102",
      meeting_location:      "Various Center City locations — see ccraonline.org",
      meeting_location_short: "Various Center City locations",

      neighborhood_description:
        "Center City is Philadelphia's central business district and most densely populated " \
        "residential neighborhood, stretching roughly from the Delaware River to the Schuylkill " \
        "River, and from South Street to Vine Street. CCRA represents residents of the core downtown " \
        "area — Rittenhouse Square, Logan Square, and the central business corridors — in zoning and " \
        "development decisions that shape the city's skyline and street life. Center City is home to " \
        "major civic institutions, cultural anchors, and the highest concentration of new residential " \
        "development in the city. CCRA is one of Philadelphia's most active and well-resourced RCOs, " \
        "with a long track record of negotiating design conditions with developers before ZBA hearings.",

      ward_explainer: nil,

      stats: [
        { number: "~55K",        label: "Residents"       },
        { number: "1st",         label: "Council District" },
        { number: "Most active", label: "RCO in Philly"   },
      ],

      issue_tags: [
        "Zoning",
        "Historic preservation",
        "Streetscape",
        "Transit",
        "Development review",
        "Affordable housing",
      ],

      gov_contacts: [
        { icon: "🏛", name: "Mark Squilla · City Council, District 1", detail: "(215) 686-3458 · district1@phila.gov" },
        { icon: "📋", name: "Licenses & Inspections",                   detail: "(215) 686-2463 · Zone: Center South"  },
        { icon: "🚔", name: "9th Police District",                      detail: "(215) 686-3030 · 401 N 21st Street"   },
        { icon: "🌳", name: "Rittenhouse Square Park",                  detail: "Parks & Rec · 18th & Walnut"          },
        { icon: "🏗", name: "Philadelphia City Planning Commission",    detail: "RCO Coordinator · (215) 683-4615"     },
      ],
    }
    render 'rcos/ccra'
  end
end
