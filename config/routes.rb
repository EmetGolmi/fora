Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "dashboard#index"
  get  "dashboard",                  to: "dashboard#show"
  post "dashboard/resolve",          to: "dashboard#resolve"
  get  "dashboard/status/:job_id",   to: "dashboard#status"
  get  "dashboard/result/:job_id",   to: "dashboard#result"
  get  "dashboard/bills",            to: "dashboard#bills"

  get "bills/:id",          to: "bills#show",         as: :bill

  # Friendly slug URLs for specific officials
  get "officials/usa/pa/jfetterman", to: "officials#show", defaults: { bioguide_id: "F000479" }
  get "officials/usa/pa/dmccormick", to: "officials#show", defaults: { bioguide_id: "M001243" }
  get "officials/usa/pa/devans",     to: "officials#show", defaults: { bioguide_id: "E000296" }
  get "officials/usa/pa/nsaval",     to: "officials#show", defaults: { bioguide_id: "nsaval" }
  get "officials/usa/pa/bwaxman",    to: "officials#show", defaults: { bioguide_id: "bwaxman" }

  # Redirect old bioguide URLs to friendly slugs for known officials
  get "officials/F000479", to: redirect("/officials/usa/pa/jfetterman")
  get "officials/M001243", to: redirect("/officials/usa/pa/dmccormick")
  get "officials/E000296", to: redirect("/officials/usa/pa/devans")

  # Redirect old OpenStates URLs to friendly slugs for Saval and Waxman
  get "officials/state/ocd-person/6f172bc8-50b0-4dd3-aed6-b5fd48b70eeb", to: redirect("/officials/usa/pa/nsaval")
  get "officials/state/ocd-person/1f2c3093-8ce7-41f7-8df0-6cd14ddd354b", to: redirect("/officials/usa/pa/bwaxman")

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
