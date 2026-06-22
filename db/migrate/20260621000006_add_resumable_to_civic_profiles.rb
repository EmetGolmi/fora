class AddResumableToCivicProfiles < ActiveRecord::Migration[8.1]
  def change
    change_table :civic_profiles do |t|
      # Resumability: which wizard step the profile is on (0 = not started).
      # Set to 2 after Step 1 saves, 3 after Temple, 4 after Forum, 5 after Market.
      # GET /join reads this so JS can go(n) to the right step.
      t.integer :onboarding_step,          default: 0, null: false

      # Links profile → ResolveAddressJob UUID kicked off at Step 1.
      # Used by GET /join/resolve to poll job status and populate the Forum civic card.
      # On POST /join/complete this value is copied into session[:dashboard_job_id]
      # so the dashboard has the user's civic data immediately on first load.
      t.string  :resolve_job_id

      # Records which verification method the user selected (postcard / id_match).
      # Drives pending-verification UI state.  residency_verified stays false here —
      # it is set only by the verification-completion flow, never by onboarding params.
      t.string  :residency_verify_method
    end
  end
end
