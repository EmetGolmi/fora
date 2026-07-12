class AddLocodeAndOccCodesToCivicProfiles < ActiveRecord::Migration[8.1]
  def change
    add_column :civic_profiles, :locode,    :string
    add_column :civic_profiles, :onet_code, :string
    add_column :civic_profiles, :isco_code, :string
  end
end
