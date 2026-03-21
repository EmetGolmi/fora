Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  root "dashboard#index"
  get "dashboard", to: "dashboard#show"
  post "dashboard/resolve", to: "dashboard#resolve"
  get "dashboard/status/:job_id", to: "dashboard#status"
  get "dashboard/result/:job_id", to: "dashboard#result"
  get "dashboard/bills", to: "dashboard#bills"
  get "bills/:id", to: "bills#show", as: :bill
  get "officials/:bioguide_id", to: "officials#show", as: :official
  get "officials/state/:openstates_id", to: "officials#state_show", as: :state_official
end
