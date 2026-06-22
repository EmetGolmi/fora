class CreateCivicProfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :civic_profiles do |t|
      t.references :user, null: false, foreign_key: true, index: true
      t.string  :display_name
      t.string  :place_label
      t.text    :bio
      # provider facet (Prompt 1 Part D — folded in here, not added separately)
      t.boolean :provider_mode,     null: false, default: false
      t.string  :provider_headline
      t.text    :service_summary
      t.jsonb   :service_area
      t.boolean :accepting_clients, null: false, default: false

      t.timestamps
    end
  end
end
