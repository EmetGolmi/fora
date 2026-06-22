class CreateFormationTracks < ActiveRecord::Migration[8.1]
  def change
    create_table :formation_tracks do |t|
      t.string  :name,          null: false
      t.string  :profession
      t.bigint  :jurisdiction_id                     # nullable, no FK (jurisdictions table does not exist yet)
      t.integer :entity_type,   null: false, default: 1
      t.text    :summary
      t.integer :min_cost_cents
      t.integer :max_cost_cents
      t.integer :authored_by,   null: false, default: 0
      t.boolean :is_published,  null: false, default: false
      t.integer :version,       null: false, default: 1

      t.timestamps
    end

    add_index :formation_tracks, :jurisdiction_id
  end
end
