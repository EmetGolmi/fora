class GovtrackService
  HARDCODED_STATS = {
    "F000479" => {
      party_vote_pct:         68.0,
      missed_votes_pct:       13.9,
      votes_cast:             "~1,205 of ~1,400",
      chamber_avg_attendance: 93.0,
      chamber_avg_party:      88.0,
      recent_votes: [
        { bill: "Pete Hegseth — Sec. of Defense confirmation", date: "Jan 25, 2025", position: "Nay" },
        { bill: "Laken Riley Act (S. 5)",                      date: "Jan 29, 2025", position: "Yea" },
        { bill: "Kash Patel — FBI Director confirmation",      date: "Feb 20, 2025", position: "Nay" },
        { bill: "FY2026 Budget Resolution",                    date: "Feb 21, 2025", position: "Nay" },
      ],
      committees: [
        { name: "Senate Committee on Agriculture, Nutrition, and Forestry",
          subcommittees: ["Commodities, Derivatives, Risk Management, and Trade",
                          "Food and Nutrition, Specialty Crops, Organics, and Research"],
          role: "Member" },
        { name: "Senate Committee on Commerce, Science, and Transportation",
          subcommittees: ["Aviation, Space, and Innovation",
                          "Telecommunications and Media"],
          role: "Member" },
        { name: "Senate Committee on Homeland Security and Governmental Affairs",
          subcommittees: ["Permanent Subcommittee on Investigations",
                          "Border Management, Federal Workforce, and Regulatory Affairs"],
          role: "Ranking Member (Border subcommittee)" },
        { name: "Commission on Security and Cooperation in Europe",
          subcommittees: [],
          role: "Member" }
      ]
    },
    "M001243" => {
      party_vote_pct:         95.0,
      missed_votes_pct:        2.8,
      votes_cast:             "~1,361 of ~1,400",
      chamber_avg_attendance: 93.0,
      chamber_avg_party:      88.0,
      recent_votes: [
        { bill: "Pete Hegseth — Sec. of Defense confirmation", date: "Jan 25, 2025", position: "Yea" },
        { bill: "Laken Riley Act (S. 5)",                      date: "Jan 29, 2025", position: "Yea" },
        { bill: "FY2026 Budget Resolution",                    date: "Feb 21, 2025", position: "Yea" },
        { bill: "FY2025 Continuing Resolution",                date: "Mar 14, 2025", position: "Yea" },
      ],
      committees: [
        { name: "Senate Committee on Banking, Housing, and Urban Affairs",
          subcommittees: [],
          role: "Member" },
        { name: "Senate Committee on Energy and Natural Resources",
          subcommittees: ["Water and Power"],
          role: "Member" },
        { name: "Senate Committee on Foreign Relations",
          subcommittees: ["Near East, South Asia, Central Asia, and Counterterrorism",
                          "East Asia, the Pacific, and International Cybersecurity Policy",
                          "Multilateral International Development, Multilateral Institutions, and International Economic, Energy, and Environmental Policy"],
          role: "Subcommittee Chair (Near East)" },
        { name: "Joint Economic Committee",
          subcommittees: [],
          role: "Member" },
        { name: "Senate Special Committee on Aging",
          subcommittees: [],
          role: "Member" }
      ]
    },
    "E000296" => {
      party_vote_pct:         96.0,
      missed_votes_pct:        8.1,
      votes_cast:             "~1,150 of ~1,350",
      chamber_avg_attendance: 95.0,
      chamber_avg_party:      92.0,
      recent_votes: [
        { bill: "Laken Riley Act (H.R. 535)",                  date: "Jan 22, 2025", position: "Nay" },
        { bill: "SAVE Act (H.R. 22)",                          date: "Apr 10, 2025", position: "Nay" },
        { bill: "One Big Beautiful Bill Act (H.R. 1)",         date: "May 22, 2025", position: "Nay" },
      ],
      committees: [
        { name: "House Committee on Ways and Means",
          subcommittees: ["Work and Welfare"],
          role: "Member" }
      ]
    },
    "B001296" => {
      party_vote_pct:         97.0,
      missed_votes_pct:        5.2,
      votes_cast:             "~1,280 of ~1,350",
      chamber_avg_attendance: 95.0,
      chamber_avg_party:      92.0,
      committees: [
        { name: "House Committee on the Budget",
          subcommittees: [],
          role: "Ranking Member" },
        { name: "House Committee on Ways and Means",
          subcommittees: [],
          role: "Member" }
      ]
    },
    "nsaval" => {
      party_vote_pct:         95.0,
      missed_votes_pct:        3.2,
      votes_cast:             "~850 of ~890",
      chamber_avg_attendance: 96.0,
      chamber_avg_party:      94.0,
      recent_votes: [
        { bill: "SB 4 — Whole-Home Repairs Program",               date: "Jul 2025",  position: "Yea" },
        { bill: "PA Fiscal Year 2025-26 Budget",                   date: "Jun 2025",  position: "Yea" },
        { bill: "PA Clean Slate Expansion (HB 689)",               date: "Apr 2025",  position: "Yea" },
        { bill: "SB 601 — Shelter First Act (first reading)",      date: "Jan 2026",  position: "Yea" },
      ],
      committees: [
        { name: "PA Senate Urban Affairs & Housing",
          subcommittees: [],
          role: "Chair" },
        { name: "PA Senate Banking & Insurance",
          subcommittees: [],
          role: "Member" },
        { name: "PA Senate Communications & Technology",
          subcommittees: [],
          role: "Member" },
        { name: "PA Senate Environmental Resources & Energy",
          subcommittees: [],
          role: "Member" }
      ]
    },
    "bwaxman" => {
      party_vote_pct:         91.0,
      missed_votes_pct:        4.8,
      votes_cast:             "~1,100 of ~1,150",
      chamber_avg_attendance: 95.0,
      chamber_avg_party:      93.0,
      recent_votes: [
        { bill: "HB 1 — Minimum Wage Increase",                    date: "Mar 2025",  position: "Yea" },
        { bill: "PA Whole-Home Repairs Program",                   date: "Jul 2025",  position: "Yea" },
        { bill: "PA FY 2025-26 Budget",                            date: "Jun 2025",  position: "Yea" },
      ],
      committees: [
        { name: "PA House Housing & Community Development",
          subcommittees: [],
          role: "Member" },
        { name: "PA House Labor & Industry",
          subcommittees: [],
          role: "Member" },
        { name: "PA House Education",
          subcommittees: [],
          role: "Member" }
      ]
    }
  }.freeze

  def self.fetch(bioguide_id)
    HARDCODED_STATS[bioguide_id] || {}
  end
end
