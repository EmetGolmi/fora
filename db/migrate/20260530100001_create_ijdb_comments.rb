class CreateIjdbComments < ActiveRecord::Migration[8.0]
  def change
    create_table :ijdb_comments, id: :uuid do |t|
      # null ijdb_entry_id = city-level comment (not attached to a specific line item)
      t.references :ijdb_entry, type: :uuid, foreign_key: true, null: true, index: true
      t.string  :city,           null: false
      t.string  :country,        default: "usa"
      t.text    :body,           null: false
      t.string  :author_name
      t.bigint  :author_user_id  # no FK — User model not yet in schema
      t.datetime :created_at,   null: false
    end

    add_index :ijdb_comments, [:city, :country]
  end
end
