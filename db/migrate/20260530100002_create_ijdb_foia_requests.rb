class CreateIjdbFoiaRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :ijdb_foia_requests, id: :uuid do |t|
      # null ijdb_entry_id = general city-level FOIA request
      t.references :ijdb_entry, type: :uuid, foreign_key: true, null: true, index: true
      t.string :city
      t.string :requester_name
      t.string :agency
      t.string :topic_key
      t.text   :letter_text
      t.string :status,               default: "drafted"   # drafted | filed | responded | appealed
      t.date   :filed_at
      t.date   :response_received_at
      t.text   :response_summary
      t.datetime :created_at,         null: false
    end

    add_index :ijdb_foia_requests, :city
    add_index :ijdb_foia_requests, :status
  end
end
