module ApplicationHelper
  OFFICIAL_SLUG_PATHS = {
    "F000479" => "/officials/usa/pa/jfetterman",
    "M001243" => "/officials/usa/pa/dmccormick",
    "E000296" => "/officials/usa/pa/devans"
  }.freeze

  def official_url_for(bioguide_id)
    OFFICIAL_SLUG_PATHS[bioguide_id] || official_path(bioguide_id)
  end
end
