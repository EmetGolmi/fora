class CreateUserFormationProgress < ActiveRecord::Migration[8.1]
  def change
    create_table :user_formation_progress do |t|
      t.references :user,     null: false, foreign_key: true, index: true
      t.bigint     :track_id, null: false
      t.bigint     :step_id,  null: false
      t.integer    :status,   null: false, default: 0
      t.bigint     :document_id                      # nullable FK → library_items, on_delete: :nullify
      t.datetime   :completed_at
      t.text       :notes

      t.timestamps
    end

    add_index :user_formation_progress, :track_id
    add_index :user_formation_progress, :step_id
    add_index :user_formation_progress, :document_id
    add_index :user_formation_progress, [:user_id, :step_id], unique: true

    add_foreign_key :user_formation_progress, :formation_tracks, column: :track_id
    add_foreign_key :user_formation_progress, :formation_steps,  column: :step_id
    add_foreign_key :user_formation_progress, :library_items,    column: :document_id, on_delete: :nullify
  end
end
