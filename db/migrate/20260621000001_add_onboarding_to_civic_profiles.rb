class AddOnboardingToCivicProfiles < ActiveRecord::Migration[8.1]
  def change
    change_table :civic_profiles do |t|
      # Identity
      t.boolean  :show_photo,          default: false, null: false
      t.string   :address_line1        # private
      t.string   :address_city
      t.string   :address_state

      # Temple — bipolar scales 1–5 (1=left pole, 5=right pole)
      t.integer  :temple_scale_reason      # reason(1)–instinct(5)
      t.integer  :temple_scale_purpose     # purpose(1)–comfort(5)
      t.integer  :temple_scale_balance     # balance(1)–grind(5)
      t.integer  :temple_scale_tradition   # own traditions(1)–many traditions(5)

      # Temple — grows + faith
      t.text     :grow_chips,          array: true, default: []
      t.string   :faith_tradition
      t.string   :faith_branch

      # Forum — service status
      t.boolean  :service_veteran,     default: false, null: false
      t.boolean  :service_active,      default: false, null: false
      t.boolean  :residency_verified,  default: false, null: false

      # Market — what you tend
      t.text     :care_tags,           array: true, default: []

      # Market — work
      t.string   :naics_code
      t.boolean  :has_entity

      # Onboarding state
      t.boolean  :onboarding_complete, default: false, null: false
    end
  end
end
