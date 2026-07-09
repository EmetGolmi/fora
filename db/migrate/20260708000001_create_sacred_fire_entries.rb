class CreateSacredFireEntries < ActiveRecord::Migration[8.1]
  def change
    create_table :sacred_fire_entries do |t|
      t.string   :tab,              null: false           # sheet name: "Jewish", "Christian", etc.
      t.string   :site_name,        null: false
      t.string   :location
      t.string   :country
      t.string   :faith_tradition
      t.string   :established                             # free string: "1429", "c.1720s", "Unknown"
      t.integer  :year_of_incident
      t.string   :cause
      t.string   :status
      t.text     :notes
      t.string   :source_citation
      t.timestamps
    end

    add_index :sacred_fire_entries, :tab
    add_index :sacred_fire_entries, :country
    add_index :sacred_fire_entries, :year_of_incident
    add_index :sacred_fire_entries, [:site_name, :year_of_incident]
  end
end
