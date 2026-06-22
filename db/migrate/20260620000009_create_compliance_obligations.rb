class CreateComplianceObligations < ActiveRecord::Migration[8.1]
  def change
    create_table :compliance_obligations do |t|
      t.bigint   :profile_id,         null: false    # FK → civic_profiles, on_delete: :cascade
      t.string   :label,              null: false
      t.integer  :obligation_type,    null: false, default: 0
      t.integer  :cadence,            null: false, default: 0
      t.date     :next_due_at,        null: false
      t.integer  :reminder_lead_days, null: false, default: 30
      t.bigint   :source_step_id                     # nullable FK → formation_steps, on_delete: :nullify
      t.bigint   :credential_id                      # nullable, no FK (CivicCredential table does not exist yet)
      t.integer  :status,             null: false, default: 0

      t.timestamps
    end

    add_index :compliance_obligations, :profile_id
    add_index :compliance_obligations, :source_step_id
    add_index :compliance_obligations, :credential_id

    add_foreign_key :compliance_obligations, :civic_profiles,  column: :profile_id,    on_delete: :cascade
    add_foreign_key :compliance_obligations, :formation_steps, column: :source_step_id, on_delete: :nullify
  end
end
