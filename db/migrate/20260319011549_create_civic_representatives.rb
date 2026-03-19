class CreateCivicRepresentatives < ActiveRecord::Migration[8.1]
  def change
    create_table :civic_representatives do |t|
      t.string :source
      t.string :external_id
      t.string :name, null: false
      t.string :office
      t.string :jurisdiction
      t.string :ocd_division_id
      t.string :party
      t.jsonb :contact, default: {}

      t.timestamps
    end

    add_index :civic_representatives, :ocd_division_id
  end
end
