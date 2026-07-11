class AddServiceRadiusToCivicProfiles < ActiveRecord::Migration[8.1]
  def change
    add_column :civic_profiles, :service_radius_mi, :decimal, precision: 5, scale: 2
  end
end
