module OfficialsHelper
  BUDGET_SEGMENT_COLORS = {
    "education"            => "#378add",
    "health"               => "#1d9e75",
    "transportation"       => "#ba7517",
    "safety"               => "#993556",
    "other"                => "#888780",
    "housing"              => "#534ab7",
    "public safety"        => "#7a1a3a",
    "economic opportunity" => "#b8860b",
    "clean & green"        => "#2d8a5e"
  }.freeze

  def budget_segment_color(category)
    BUDGET_SEGMENT_COLORS[category.to_s.downcase] || "#888780"
  end
end
