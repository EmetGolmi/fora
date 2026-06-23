class CreateProjects < ActiveRecord::Migration[8.1]
  def change
    create_table :projects do |t|
      t.references :civic_profile, null: false, foreign_key: { on_delete: :cascade }
      t.string :title, null: false
      t.timestamps
    end

    create_table :project_items do |t|
      t.references :project, null: false, foreign_key: { on_delete: :cascade }
      t.string  :itemable_type, null: false
      t.bigint  :itemable_id,   null: false
      t.timestamps
    end

    # A thing can only appear once in a given project.
    add_index :project_items,
              [:project_id, :itemable_type, :itemable_id],
              unique: true,
              name: "idx_project_items_unique"

    # Reverse lookup: "which projects contain this bill?"
    add_index :project_items, [:itemable_type, :itemable_id],
              name: "idx_project_items_on_itemable"
  end
end
