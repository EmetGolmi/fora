class AddFaithDetailToCivicProfiles < ActiveRecord::Migration[8.1]
  def change
    add_column :civic_profiles, :faith_ethnicity, :string
    add_column :civic_profiles, :faith_culture, :string
  end
end
