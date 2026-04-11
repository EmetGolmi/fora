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
    render :show
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
    render :show
  end
end
