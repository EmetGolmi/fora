class CreateFormationSteps < ActiveRecord::Migration[8.1]
  def change
    create_table :formation_steps do |t|
      t.references :track, null: false, index: true,
                   foreign_key: { to_table: :formation_tracks, on_delete: :cascade }
      t.string  :phase,             null: false
      t.string  :title,             null: false
      t.text    :body,              null: false
      t.integer :requirement,       null: false, default: 0
      t.string  :cost_range
      t.jsonb   :action_links,      null: false, default: []
      t.string  :save_as
      t.string  :naics_code
      t.integer :display_order,     null: false, default: 0
      t.bigint  :supersedes_id                       # self-reference, no FK constraint
      t.boolean :community_refined, null: false, default: false

      t.timestamps
    end

    add_index :formation_steps, :supersedes_id
  end
end
