class CreateCivicBills < ActiveRecord::Migration[8.1]
  def change
    create_table :civic_bills do |t|
      t.string :source, null: false
      t.string :external_id, null: false
      t.string :jurisdiction, null: false
      t.string :identifier
      t.string :title, null: false
      t.text :summary
      t.string :status
      t.date :status_date
      t.string :full_text_url
      t.jsonb :sponsors, default: []
      t.jsonb :subjects, default: []
      t.jsonb :votes, default: []
      t.jsonb :raw_data

      t.timestamps
    end

    add_index :civic_bills, [:source, :external_id], unique: true
    add_index :civic_bills, :jurisdiction
    add_index :civic_bills, :status_date
  end
end
