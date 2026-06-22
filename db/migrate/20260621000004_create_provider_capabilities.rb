class CreateProviderCapabilities < ActiveRecord::Migration[8.1]
  def change
    create_table :provider_capabilities do |t|
      t.references :civic_profile, null: false, foreign_key: true
      t.string     :profession,    null: false   # e.g. "home_inspector", "painter"
      t.integer    :status,        default: 0, null: false  # 0=active, 1=inactive
      t.string     :naics_code

      t.timestamps
    end

    # One profession per profile
    add_index :provider_capabilities, [ :civic_profile_id, :profession ], unique: true
  end
end
