class AddCoordsToSacredFireEntries < ActiveRecord::Migration[8.1]
  def change
    add_column :sacred_fire_entries, :latitude,  :decimal, precision: 9, scale: 6
    add_column :sacred_fire_entries, :longitude, :decimal, precision: 9, scale: 6
    add_index  :sacred_fire_entries, [:latitude, :longitude]
  end
end
