class CreateConnections < ActiveRecord::Migration[8.1]
  def change
    create_table :connections do |t|
      t.references :civic_profile, null: false, foreign_key: { on_delete: :cascade }

      # The followed thing this connection originates FROM.
      # Always present — you must have Sparked before you can Build.
      t.string  :source_type, null: false
      t.bigint  :source_id,   null: false

      # The OTHER thing this source is being linked TO.
      # Optional — a Build with only a note and no link is valid.
      t.string  :target_type
      t.bigint  :target_id

      # The user's own take / note on this connection.
      # At least one of (target_id, note) must be present — validated in model.
      t.text :note

      t.timestamps
    end

    add_index :connections, [:source_type, :source_id], name: "idx_connections_on_source"
    add_index :connections, [:target_type, :target_id], name: "idx_connections_on_target",
              where: "target_id IS NOT NULL"
    add_index :connections, [:civic_profile_id, :source_type, :source_id],
              name: "idx_connections_on_profile_and_source"
  end
end
