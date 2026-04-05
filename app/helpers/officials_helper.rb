module OfficialsHelper
  BUDGET_SEGMENT_COLORS = {
    "education"      => "#378add",
    "health"         => "#1d9e75",
    "transportation" => "#ba7517",
    "safety"         => "#993556",
    "other"          => "#888780"
  }.freeze

  def budget_segment_color(category)
    BUDGET_SEGMENT_COLORS[category.to_s.downcase] || "#888780"
  end
end
