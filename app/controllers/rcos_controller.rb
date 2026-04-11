class RcosController < ApplicationController
  # Shared government contacts for Council District 7 / 19122
  DISTRICT_7_GOV_CONTACTS = [
    { icon: "🏛", name: "Quetcy Lozada",  detail: "Philadelphia City Council · District 7" },
    { icon: "🏢", name: "Nikil Saval",    detail: "Pennsylvania Senate · District 1"       },
    { icon: "🏛", name: "Joe Giral",      detail: "Pennsylvania House of Representatives"  },
  ].freeze

  # "19wc" starts with a digit and cannot be a regular Ruby method name,
  # so we use define_method with a string key — Rails dispatches via send().
  define_method("19wc") do
    @rco = {
      name:             "19th Ward Committee RCO",
      slug:             "19wc",
      neighborhood:     "West Kensington",
      zip:              "19122",
      ward_committee:   true,
      council_district: 7,

      address:          "2122 N Hancock Street, Philadelphia, PA 19122",
      meeting_location: "147 W. Susquehanna Avenue, Philadelphia, PA 19122",
      meeting_location_short: "147 W. Susquehanna Ave",

      primary_name:     "Maria Matos",
      primary_email:    "philly19thward@gmail.com",
      primary_phone:    "(267) 236-9857",
      expiration_year:  2027,
      website:          nil,

      neighborhood_description:
        "<strong>West Kensington</strong> is a working-class North Philadelphia neighborhood " \
        "anchored by row-home blocks, small businesses, and longstanding community institutions " \
        "stretching north from Lehigh Avenue. The 19th political ward spans this geography, and its " \
        "dual role as electoral organization and RCO means the same group that turns out voters in " \
        "November also has formal standing when a developer files for a zoning variance on your block. " \
        "Development pressure has intensified as adjacent corridors shift, making the ward's zoning " \
        "oversight role increasingly consequential for residents.",

      stats: [
        { number: "19th",  label: "Political Ward"   },
        { number: "7th",   label: "Council District" },
        { number: "2027",  label: "Active Through"   },
      ],

      issues: [
        "Zoning & Variance",
        "Liquor Licensing",
        "Housing & Development",
        "Public Safety",
      ],

      ward_explainer:
        "<strong>Ward Committee RCOs</strong> are a distinctive feature of Philadelphia's civic " \
        "structure. Each of the city's 69 political wards elects a Democratic ward leader and a " \
        "committee of ward representatives. When a ward committee registers with the Philadelphia " \
        "Planning Commission as an RCO, it gains formal standing in the city's zoning notification " \
        "process — allowing it to request community meetings on variance applications within its " \
        "boundaries. This gives the 19th Ward Committee a dual role: the same organization that " \
        "mobilizes voters each November also holds a seat at the table when something is being built " \
        "or changed in your neighborhood.",

      gov_contacts: DISTRICT_7_GOV_CONTACTS,
    }
    render :show
  end

  def nscan
    @rco = {
      name:             "Norris Square Community Action Network",
      slug:             "nscan",
      neighborhood:     "Norris Square",
      zip:              "19122",
      ward_committee:   false,
      council_district: 7,

      address:          "c/o West Kensington Ministry, 2140 N. Hancock Street, Philadelphia, PA 19122",
      meeting_location: "West Kensington Ministry, 2140 N Hancock Street, Philadelphia, PA 19122",
      meeting_location_short: "West Kensington Ministry",

      primary_name:     "Nilda L. Pimentel-Perez",
      primary_email:    "contact@nscanphilly.org",
      primary_phone:    "(267) 231-9470",
      expiration_year:  2026,
      website:          "www.nscanphilly.org",

      neighborhood_description:
        "<strong>Norris Square</strong> is a majority-Latino neighborhood in the Kensington section " \
        "of North Philadelphia, centered on the historic park at Hancock and Susquehanna — a green " \
        "anchor stewarded in partnership with community volunteers. NSCAN has organized residents here " \
        "for decades, connecting neighbors to city planning processes, supporting green space advocacy, " \
        "and pushing back on displacement as development pressure grows along nearby corridors. The " \
        "neighborhood maintains a strong sense of place and cultural identity rooted in its Puerto " \
        "Rican community history.",

      stats: [
        { number: "7th",   label: "Council District" },
        { number: "19122", label: "Zip Code"          },
        { number: "2026",  label: "Active Through"    },
      ],

      issues: [
        "Community Development",
        "Housing & Displacement",
        "Environmental Justice",
        "Youth & Education",
      ],

      ward_explainer: nil,

      gov_contacts: DISTRICT_7_GOV_CONTACTS,
    }
    render :show
  end
end
