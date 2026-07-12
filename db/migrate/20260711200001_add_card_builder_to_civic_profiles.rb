class AddCardBuilderToCivicProfiles < ActiveRecord::Migration[8.1]
  def change
    # provider_headline already exists from an earlier migration
    add_column :civic_profiles, :provider_handle,       :string
    add_column :civic_profiles, :card_builder_step,     :integer, default: 0, null: false
    add_column :civic_profiles, :card_builder_complete, :boolean, default: false, null: false

    add_index  :civic_profiles, :provider_handle, unique: true,
               where: "provider_handle IS NOT NULL"
  end
end
