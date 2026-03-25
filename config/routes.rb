Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "dashboard#index"
  get  "dashboard",                  to: "dashboard#show"
  post "dashboard/resolve",          to: "dashboard#resolve"
  get  "dashboard/status/:job_id",   to: "dashboard#status"
  get  "dashboard/result/:job_id",   to: "dashboard#result"
  get  "dashboard/bills",            to: "dashboard#bills"

  get "bills/:id",          to: "bills#show",         as: :bill

  # Bioguide IDs are always one uppercase letter + six digits (e.g. F000479)
  # Constraint prevents "state" from matching as a bioguide_id
  get "officials/:bioguide_id",
      to: "officials#show",
      as: :official,
      constraints: { bioguide_id: /[A-Z]\d{6}/ }

  get "/officials/state/*openstates_id",
      to:  "officials#state_show",
      as:  :state_official

  # Business formation guide
  get  "market/newllc",       to: "market/new_llc#index", as: :new_llc
  get  "market/newllc/guide", to: "market/new_llc#guide", as: :new_llc_guide
end
