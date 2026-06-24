class AddPillarIdentitiesToCivicProfiles < ActiveRecord::Migration[8.1]
  def change
    add_column :civic_profiles, :temple_handle, :string
    add_column :civic_profiles, :forum_pseudonym, :string
    add_column :civic_profiles, :market_display_name, :string
    add_column :civic_profiles, :market_entity_name, :string
  end
end
