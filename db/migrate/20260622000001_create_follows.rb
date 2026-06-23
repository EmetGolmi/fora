class CreateFollows < ActiveRecord::Migration[8.1]
  def change
    create_table :follows do |t|
      t.references :civic_profile, null: false, foreign_key: { on_delete: :cascade }
      t.string  :followable_type, null: false   # "CivicBill" | "NeighborhoodIssue" | "CivicRepresentative"
      t.bigint  :followable_id,   null: false
      t.timestamps
    end

    # Enforce one follow per (profile, thing) — the unique constraint IS the
    # business logic.  Spark twice = no-op / toggle handled in the controller.
    add_index :follows,
              [:civic_profile_id, :followable_type, :followable_id],
              unique: true,
              name: "idx_follows_unique"

    # Reverse lookup: "who follows this bill?"
    add_index :follows, [:followable_type, :followable_id],
              name: "idx_follows_on_followable"
  end
end
