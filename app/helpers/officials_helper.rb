module OfficialsHelper
  BUDGET_SEGMENT_COLORS = {
    "education"            => "#378add",
    "health"               => "#1d9e75",
    "human services"       => "#0d7a5a",
    "transportation"       => "#ba7517",
    "safety"               => "#993556",
    "other"                => "#888780",
    "housing"              => "#534ab7",
    "public safety"        => "#7a1a3a",
    "economic opportunity" => "#b8860b",
    "clean & green"        => "#2d8a5e",
    "criminal prosecution" => "#7a1515",
    "civil litigation"     => "#1b5fa8",
    "consumer protection"  => "#1d9e75",
    "administration"       => "#888780"
  }.freeze

  # Preferred display order per office type — overrides JSONB key-length sorting
  BUDGET_ORDER = {
    "governor"         => %w[education health] + ["human services"] + %w[transportation safety other],
    "mayor"            => ["public safety", "economic opportunity", "housing", "clean & green", "education"],
    "attorney_general" => ["criminal prosecution", "civil litigation", "consumer protection", "administration"]
  }.freeze

  BUDGET_DESCRIPTIONS = {
    "education"            => "Funds K-12 public schools, Pre-K expansion, higher education financial aid, special education programs, and school safety initiatives. The largest single line item in Pennsylvania's budget.",
    "health"               => "Covers Medical Assistance (Pennsylvania's Medicaid program) and the Children's Health Insurance Program (CHIP), providing health coverage to more than 3 million low-income Pennsylvanians.",
    "human services"       => "Funds the Department of Human Services: disability services, child welfare and foster care, domestic violence programs, SNAP administration, and cash assistance for low-income families.",
    "transportation"       => "Supports PennDOT highway and bridge maintenance, public transit systems (SEPTA, Port Authority, and regional transit), and multi-year infrastructure modernization projects.",
    "safety"               => "Funds the Pennsylvania State Police, Department of Corrections, Office of State Fire Commissioner, and emergency management and disaster preparedness operations.",
    "other"                => "Covers general government operations, legislative and judicial branch support, debt service, environmental programs, and cross-agency initiatives not categorized elsewhere.",
    "public safety"        => "Covers the Philadelphia Police Department, Fire Department, EMS, the prison system, the District Attorney's office, and the Office of Emergency Management.",
    "economic opportunity" => "Funds workforce development, job training programs, small business support, Commerce Department operations, and economic inclusion initiatives citywide.",
    "housing"              => "Supports the Philadelphia Housing Authority, affordable housing development, the Office of Homeless Services, and rental and homeownership assistance programs.",
    "clean & green"        => "Covers Philadelphia Parks & Recreation, the Office of Sustainability, clean energy initiatives, stormwater management, and Water Revenue Fund programs.",
    "criminal prosecution" => "Funds prosecutorial divisions, criminal investigation units, and the litigation costs of bringing criminal cases on behalf of the Commonwealth of Pennsylvania.",
    "civil litigation"     => "Covers the AG office's civil divisions, including defense of state agencies in lawsuits and affirmative civil enforcement actions against corporations and bad actors.",
    "consumer protection"  => "Funds the Bureau of Consumer Protection, which investigates fraud, deceptive advertising, predatory lending, and scams targeting Pennsylvania consumers.",
    "administration"       => "General administration, information technology, human resources, legal counsel, and operational overhead for the Office of Attorney General."
  }.freeze

  def budget_segment_color(category)
    BUDGET_SEGMENT_COLORS[category.to_s.downcase] || "#888780"
  end

  def budget_description(category)
    BUDGET_DESCRIPTIONS[category.to_s.downcase] || "Budget allocation for #{category.capitalize}."
  end

  # Returns the budget breakdown sorted in the preferred display order for this office type.
  # Prevents JSONB key-length sorting from grouping unrelated categories visually.
  def budget_sorted(official)
    order = BUDGET_ORDER[official.office_type] || []
    bd    = official.budget_breakdown.transform_keys(&:to_s)
    sorted    = order.filter_map { |k| [k, bd[k]] if bd.key?(k) }
    remaining = bd.reject { |k, _| order.include?(k) }.to_a
    (sorted + remaining).to_h
  end
end
