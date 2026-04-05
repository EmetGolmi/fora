class CommitteeDataService
  COMMITTEES = {
    "senate-agriculture" => {
      full_name:       "Senate Committee on Agriculture, Nutrition, and Forestry",
      description:     "Oversees farming policy, SNAP and food assistance, rural development, forestry, crop insurance, and the Farm Bill — the primary vehicle for U.S. agricultural and nutrition policy. Covers the USDA broadly.",
      chair:           "John Boozman (R-AR)",
      ranking_member:  "Amy Klobuchar (D-MN)",
      url:             "https://www.agriculture.senate.gov",
      republicans:     ["John Boozman (Chair)", "Chuck Grassley", "John Thune", "John Hoeven", "Joni Ernst", "Deb Fischer", "Jerry Moran", "Roger Marshall", "Tommy Tuberville", "Cindy Hyde-Smith", "Mitch McConnell", "James Justice", "Tom Cotton"],
      democrats:       ["Amy Klobuchar (Ranking Member)", "Richard Durbin", "Michael Bennet", "Tina Smith", "Peter Welch", "Raphael Warnock", "John Fetterman", "Cory Booker", "Ben Ray Luján", "Adam Schiff", "Elissa Slotkin"]
    }.freeze,
    "senate-commerce" => {
      full_name:       "Senate Committee on Commerce, Science, and Transportation",
      description:     "Covers interstate commerce, aviation, rail, telecommunications, broadband, consumer protection, science, space policy, and the Coast Guard. Oversees the FCC, FTC, FAA, NOAA, and NASA.",
      chair:           "Ted Cruz (R-TX)",
      ranking_member:  "Maria Cantwell (D-WA)",
      url:             "https://www.commerce.senate.gov",
      republicans:     ["Ted Cruz (Chair)", "John Thune", "Roger Wicker", "Deb Fischer", "Jerry Moran", "Dan Sullivan", "Marsha Blackburn", "Todd Young", "Ted Budd", "Eric Schmitt", "John Curtis", "Bernie Moreno", "Tim Sheehy", "Shelley Moore Capito", "Cynthia Lummis", "Ashley Moody"],
      democrats:       ["Maria Cantwell (Ranking Member)", "Amy Klobuchar", "Brian Schatz", "Edward Markey", "Gary Peters", "Tammy Baldwin", "Tammy Duckworth", "Jacky Rosen", "Ben Ray Luján", "John Hickenlooper", "John Fetterman", "Andy Kim", "Lisa Blunt Rochester"]
    }.freeze,
    "senate-homeland-security" => {
      full_name:       "Senate Committee on Homeland Security and Governmental Affairs",
      description:     "Senate's chief oversight committee. Covers DHS, federal operations, the Postal Service, border management, civil service, and government contracting. Houses the Permanent Subcommittee on Investigations.",
      chair:           "Rand Paul (R-KY)",
      ranking_member:  "Gary Peters (D-MI)",
      url:             "https://www.hsgac.senate.gov",
      republicans:     ["Rand Paul (Chair)", "Ron Johnson", "James Lankford", "Rick Scott", "Josh Hawley", "Bernie Moreno", "Joni Ernst", "Ashley Moody"],
      democrats:       ["Gary Peters (Ranking Member)", "Maggie Hassan", "Richard Blumenthal", "John Fetterman", "Andy Kim", "Ruben Gallego", "Elissa Slotkin"]
    }.freeze,
    "senate-banking" => {
      full_name:       "Senate Committee on Banking, Housing, and Urban Affairs",
      description:     "Oversees banking, financial regulation, housing policy, mass transit, international finance, and crypto/digital assets. Covers the Federal Reserve, Treasury, CFPB, HUD, Fannie Mae, and Freddie Mac.",
      chair:           "Tim Scott (R-SC)",
      ranking_member:  "Elizabeth Warren (D-MA)",
      url:             "https://www.banking.senate.gov",
      republicans:     ["Tim Scott (Chair)", "Mike Crapo", "Mike Rounds", "Thom Tillis", "John Kennedy", "Bill Hagerty", "Cynthia Lummis", "Katie Britt", "Pete Ricketts", "Jim Banks", "Kevin Cramer", "Bernie Moreno", "Dave McCormick"],
      democrats:       ["Elizabeth Warren (Ranking Member)", "Jack Reed", "Mark Warner", "Chris Van Hollen", "Catherine Cortez Masto", "Tina Smith", "Raphael Warnock", "Andy Kim", "Ruben Gallego", "Lisa Blunt Rochester", "Angela Alsobrooks"]
    }.freeze,
    "senate-energy" => {
      full_name:       "Senate Committee on Energy and Natural Resources",
      description:     "Covers energy policy, nuclear energy, public lands, national parks, wilderness, mining, and water resources. Oversees the DOE, Bureau of Land Management, National Park Service, and Forest Service.",
      chair:           "Mike Lee (R-UT)",
      ranking_member:  "Martin Heinrich (D-NM)",
      url:             "https://www.energy.senate.gov",
      republicans:     ["Mike Lee (Chair)", "John Barrasso", "James Risch", "Steve Daines", "Tom Cotton", "James Justice", "Dave McCormick", "Bill Cassidy", "Cindy Hyde-Smith", "Lisa Murkowski", "John Hoeven"],
      democrats:       ["Martin Heinrich (Ranking Member)", "Ron Wyden", "Maria Cantwell", "Mazie Hirono", "Angus King (I-ME)", "Catherine Cortez Masto", "John Hickenlooper", "Alex Padilla", "Ruben Gallego"]
    }.freeze,
    "senate-foreign-relations" => {
      full_name:       "Senate Committee on Foreign Relations",
      description:     "Jurisdiction over all treaties, the State Department, foreign assistance, arms control, and U.S. foreign policy. Reviews nominations for ambassadors and senior diplomatic officials and provides advice and consent on treaties.",
      chair:           "James Risch (R-ID)",
      ranking_member:  "Jeanne Shaheen (D-NH)",
      url:             "https://www.foreign.senate.gov",
      republicans:     ["James Risch (Chair)", "Pete Ricketts", "Dave McCormick", "Steve Daines", "Bill Hagerty", "John Barrasso", "Mike Lee", "Rand Paul", "Ted Cruz", "Rick Scott", "John Curtis", "John Cornyn"],
      democrats:       ["Jeanne Shaheen (Ranking Member)", "Chris Coons", "Chris Murphy", "Tim Kaine", "Jeff Merkley", "Cory Booker", "Brian Schatz", "Chris Van Hollen", "Tammy Duckworth", "Jacky Rosen"]
    }.freeze,
    "joint-economic" => {
      full_name:       "Joint Economic Committee",
      description:     "Bicameral committee studying the U.S. economy and advising Congress on fiscal, monetary, and economic policy. Issues reports and hearings; does not directly advance legislation. Membership spans both the Senate and House.",
      chair:           "Rep. David Schweikert (R-AZ, House)",
      ranking_member:  "Sen. Maggie Hassan (D-NH, Senate)",
      url:             "https://www.jec.senate.gov",
      republicans:     ["Sen. Eric Schmitt (Vice Chair)", "Sen. Tom Cotton", "Sen. Ted Budd", "Sen. Dave McCormick", "Sen. Marsha Blackburn", "Sen. Jerry Moran", "Rep. David Schweikert (Chair)", "Rep. Jodey Arrington", "Rep. Ron Estes", "Rep. Lloyd Smucker", "Rep. Nicole Malliotakis", "Rep. Victoria Spartz"],
      democrats:       ["Sen. Maggie Hassan (Ranking Member)", "Sen. Amy Klobuchar", "Sen. Martin Heinrich", "Sen. Mark Kelly", "Rep. Don Beyer", "Rep. Gwen Moore", "Rep. Sean Casten", "Rep. Dave Min"]
    }.freeze,
    "senate-aging" => {
      full_name:       "Senate Special Committee on Aging",
      description:     "Non-legislative oversight committee focused on Medicare, Social Security, retirement security, elder fraud, long-term care, and prescription drug costs. Maintains a national senior fraud hotline (1-855-303-9470).",
      chair:           "Rick Scott (R-FL)",
      ranking_member:  "Kirsten Gillibrand (D-NY)",
      url:             "https://www.aging.senate.gov",
      republicans:     ["Rick Scott (Chair)", "Dave McCormick", "James Justice", "Tommy Tuberville", "Ron Johnson", "Ashley Moody", "Jon Husted"],
      democrats:       ["Kirsten Gillibrand (Ranking Member)", "Elizabeth Warren", "Mark Kelly", "Raphael Warnock", "Andy Kim", "Angela Alsobrooks"]
    }.freeze,
    "house-ways-means" => {
      full_name:       "House Committee on Ways and Means",
      description:     "Oldest and most powerful House committee. Has sole jurisdiction over all revenue-raising legislation: federal taxes, trade and tariffs, Social Security, Medicare, unemployment insurance, and welfare programs.",
      chair:           "Jason Smith (R-MO)",
      ranking_member:  "Richard Neal (D-MA)",
      url:             "https://waysandmeans.house.gov",
      republicans:     ["Jason Smith (Chair)", "Vern Buchanan", "Adrian Smith", "Mike Kelly", "David Schweikert", "Darin LaHood", "Jodey Arrington", "Ron Estes", "Lloyd Smucker", "Kevin Hern", "Carol Miller", "Greg Murphy", "David Kustoff", "Brian Fitzpatrick", "Greg Steube", "Claudia Tenney", "Michelle Fischbach", "Blake Moore", "Beth Van Duyne", "Randy Feenstra", "Nicole Malliotakis", "Mike Carey", "Rudy Yakym", "Max Miller", "Aaron Bean", "Nathaniel Moran"],
      democrats:       ["Richard Neal (Ranking Member)", "Lloyd Doggett", "Mike Thompson", "John Larson", "Danny Davis", "Linda Sánchez", "Terri Sewell", "Suzan DelBene", "Judy Chu", "Gwen Moore", "Brendan Boyle", "Don Beyer", "Dwight Evans", "Brad Schneider", "Jimmy Panetta", "Jimmy Gomez", "Steven Horsford", "Stacey Plaskett", "Tom Suozzi"]
    }.freeze
  }.freeze

  NAME_TO_SLUG = {
    "Senate Committee on Agriculture, Nutrition, and Forestry"      => "senate-agriculture",
    "Senate Committee on Commerce, Science, and Transportation"      => "senate-commerce",
    "Senate Committee on Homeland Security and Governmental Affairs" => "senate-homeland-security",
    "Senate Committee on Banking, Housing, and Urban Affairs"        => "senate-banking",
    "Senate Committee on Energy and Natural Resources"               => "senate-energy",
    "Senate Committee on Foreign Relations"                          => "senate-foreign-relations",
    "Joint Economic Committee"                                        => "joint-economic",
    "Senate Special Committee on Aging"                              => "senate-aging",
    "House Committee on Ways and Means"                              => "house-ways-means"
  }.freeze

  def self.slug_for(name)
    NAME_TO_SLUG[name]
  end

  def self.for_slug(slug)
    COMMITTEES[slug]
  end

  # Returns a JS-safe object (snake_case → camelCase) for all committees
  def self.js_data
    COMMITTEES.transform_values do |v|
      {
        name:          v[:full_name],
        description:   v[:description],
        chair:         v[:chair],
        rankingMember: v[:ranking_member],
        url:           v[:url],
        republicans:   v[:republicans],
        democrats:     v[:democrats]
      }
    end
  end
end
