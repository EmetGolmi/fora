Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  get  "about",     to: "pages#about",    as: :about
  get  "mc",        to: "pages#mc",       as: :mc
  get  "votemay19",         to: "vote#may19",    as: :votemay19
  post "votemay19/cast",    to: "vote#cast",     as: :votemay19_cast
  get  "votemay19/results", to: "vote#results",  as: :votemay19_results

  root "dashboard#index"
  get  "dashboard",                  to: "dashboard#show",   as: :dashboard
  get  "dashboard/clear",            to: "dashboard#clear",  as: :dashboard_clear
  post "dashboard/resolve",          to: "dashboard#resolve"
  get  "dashboard/status/:job_id",   to: "dashboard#status"
  get  "dashboard/result/:job_id",   to: "dashboard#result"
  get  "dashboard/bills",            to: "dashboard#bills"

  get  "bills/:id",          to: "bills#show",         as: :bill
  get  "bills/:bill_id/comments", to: "bill_comments#index",  as: :bill_comments
  post "bills/:bill_id/comments", to: "bill_comments#create"
  get "eo/:id",             to: "executive_orders#show", as: :executive_order

  # Friendly slug URLs for specific officials
  get "officials/usa/pa/jfetterman", to: "officials#show", defaults: { bioguide_id: "F000479" }
  get "officials/usa/pa/dmccormick", to: "officials#show", defaults: { bioguide_id: "M001243" }
  get "officials/usa/pa/devans",     to: "officials#show", defaults: { bioguide_id: "E000296" }
  get "officials/usa/pa/nsaval",       to: "officials#show", defaults: { bioguide_id: "nsaval" }
  get "officials/usa/pa/bwaxman",      to: "officials#show", defaults: { bioguide_id: "bwaxman" }
  get "officials/usa/pa/jgiral",       to: "officials#show", defaults: { bioguide_id: "jgiral" }
  get "officials/usa/pa/ttartaglione", to: "officials#show", defaults: { bioguide_id: "ttartaglione" }
  get "officials/usa/president",          to: "officials#us_president", as: :us_president
  get "officials/usa/vp",                to: "officials#us_vp",        as: :us_vp
  get "officials/usa/pa/governor",        to: "officials#governor",     as: :pa_governor
  get "officials/usa/pa/lt-governor",     to: "officials#lt_governor",  as: :pa_lt_governor
  get "officials/usa/pa/philly/mayor",                to: "officials#philly_mayor",                as: :philly_mayor
  get "officials/usa/pa/philly/council-president",    to: "officials#philly_council_president",    as: :philly_council_president
  get "officials/usa/pa/philly/majority-leader",      to: "officials#philly_majority_leader",      as: :philly_majority_leader
  get "officials/usa/pa/philly/majority-whip",        to: "officials#philly_majority_whip",        as: :philly_majority_whip
  get "officials/usa/pa/philly/minority-leader",      to: "officials#philly_minority_leader",      as: :philly_minority_leader
  get "officials/usa/pa/philly/minority-whip",        to: "officials#philly_minority_whip",        as: :philly_minority_whip
  get "officials/usa/pa/philly/deputy-majority-whip", to: "officials#philly_deputy_majority_whip", as: :philly_deputy_majority_whip
  get "officials/usa/pa/philly/managing-director",    to: "officials#philly_managing_director",    as: :philly_managing_director
  get "officials/usa/pa/philly/finance-director",     to: "officials#philly_finance_director",     as: :philly_finance_director
  get "officials/usa/pa/philly/district-1",           to: "officials#philly_district_1",           as: :philly_district_1
  get "officials/usa/pa/philly/district-2",           to: "officials#philly_district_2",           as: :philly_district_2
  get "officials/usa/pa/philly/district-3",           to: "officials#philly_district_3",           as: :philly_district_3
  get "officials/usa/pa/philly/district-4",           to: "officials#philly_district_4",           as: :philly_district_4
  get "officials/usa/pa/philly/district-5",           to: "officials#philly_district_5",           as: :philly_district_5
  get "officials/usa/pa/philly/district-6",           to: "officials#philly_district_6",           as: :philly_district_6
  get "officials/usa/pa/philly/district-7",           to: "officials#philly_district_7",           as: :philly_district_7
  get "officials/usa/pa/philly/district-8",           to: "officials#philly_district_8",           as: :philly_district_8
  get "officials/usa/pa/philly/district-9",           to: "officials#philly_district_9",           as: :philly_district_9
  get "officials/usa/pa/philly/district-10",          to: "officials#philly_district_10",          as: :philly_district_10
  get "officials/usa/pa/philly/at-large-nina-ahmad",  to: "officials#philly_al_ahmad",             as: :philly_al_ahmad
  get "officials/usa/pa/philly/at-large-jim-harrity", to: "officials#philly_al_harrity",           as: :philly_al_harrity
  get "officials/usa/pa/philly/at-large-rue-landau",  to: "officials#philly_al_landau",            as: :philly_al_landau
  get "officials/usa/pa/philly/:slug",                to: "officials#philly_person",               as: :philly_person

  # Redirect old bioguide URLs to friendly slugs for known officials
  get "officials/F000479", to: redirect("/officials/usa/pa/jfetterman")
  get "officials/M001243", to: redirect("/officials/usa/pa/dmccormick")
  get "officials/E000296", to: redirect("/officials/usa/pa/devans")

  # Redirect old OpenStates URLs to friendly slugs for state officials
  get "officials/state/ocd-person/6f172bc8-50b0-4dd3-aed6-b5fd48b70eeb", to: redirect("/officials/usa/pa/nsaval")
  get "officials/state/ocd-person/1f2c3093-8ce7-41f7-8df0-6cd14ddd354b", to: redirect("/officials/usa/pa/bwaxman")
  get "officials/state/ocd-person/d390f1ac-1f16-478a-9e0d-462c9ed79818", to: redirect("/officials/usa/pa/jgiral")
  get "officials/state/ocd-person/f3b4fe8c-05f9-4610-81ef-354c0fcb0cdd", to: redirect("/officials/usa/pa/ttartaglione")

  # Bioguide IDs are always one uppercase letter + six digits (e.g. F000479)
  # Constraint prevents "state" from matching as a bioguide_id
  get "officials/:bioguide_id",
      to: "officials#show",
      as: :official,
      constraints: { bioguide_id: /[A-Z]\d{6}/ }

  get "/officials/state/*openstates_id",
      to:  "officials#state_show",
      as:  :state_official

  # Community organizations
  get "usa/pa/philly/rco/bvna",     to: "orgs#bvna",       as: :bvna_rco
  get "usa/pa/philly/rco/19wc",         to: "rcos#19wc",         as: :rco_19wc
  get "usa/pa/philly/rco/nscan",        to: "rcos#nscan",        as: :rco_nscan
  get "usa/pa/philly/rco/ccra",         to: "rcos#ccra",         as: :rco_ccra
  get "usa/pa/philly/rco/fishtown",     to: "rcos#fishtown",     as: :rco_fishtown
  get "usa/pa/philly/rco/fkabid",       to: "rcos#fkabid",      as: :rco_fkabid
  get "usa/pa/philly/rco/wgirard",      to: "rcos#wgirard",     as: :rco_wgirard
  get "usa/pa/philly/rco/epcrossing",   to: "rcos#epcrossing",  as: :rco_epcrossing

  # Redirects from old broken slugs (must come before the catch-all)
  get "usa/pa/philly/rco/epca",                                                    to: redirect("/usa/pa/philly/rco/epcrossing")
  get "usa/pa/philly/rco/fishtown-neighbors-association",                          to: redirect("/usa/pa/philly/rco/fishtown")
  get "usa/pa/philly/rco/fishtown-kensington-area-business-improvement-district",  to: redirect("/usa/pa/philly/rco/fkabid")
  get "usa/pa/philly/rco/west-girard-progress",                                    to: redirect("/usa/pa/philly/rco/wgirard")

  # Generic fallback for any other RCO slug (must come last)
  get "usa/pa/philly/rco/:slug", to: "rcos#generic"

  # Neighborhood Issues API (scoped per RCO)
  scope '/usa/pa/philly/rco/:rco_slug' do
    resources :neighborhood_issues, only: [:index, :create] do
      member do
        post :concur
      end
      resources :issue_responses, only: [:create]
    end
  end

  # Candidates
  get '/candidates/chris-rabb',           to: 'candidates#chris_rabb',           as: 'candidate_chris_rabb'
  get '/candidates/john-allante-mcauley', to: 'candidates#john_allante_mcauley', as: 'candidate_john_allante_mcauley'
  get '/candidates/:slug',      to: 'candidates#show',       as: 'candidate'

  # Business formation guide
  get  "market/newllc",       to: "market/new_llc#index", as: :new_llc
  get  "market/newllc/guide", to: "market/new_llc#guide", as: :new_llc_guide
end
