class AddExternalIdsAndCreateOfficialFinanceSummaries < ActiveRecord::Migration[8.1]
  def change
    add_column :civic_representatives, :external_ids, :jsonb, default: {}
    add_index  :civic_representatives, :external_ids, using: :gin

    create_table :official_finance_summaries do |t|
      t.references :civic_representative, null: false, foreign_key: true
      t.string  :fec_candidate_id, null: false
      t.integer :cycle_year, null: false
      t.bigint  :total_raised_cents
      t.bigint  :total_spent_cents
      t.bigint  :cash_on_hand_cents
      t.bigint  :individual_contrib_cents
      t.bigint  :pac_contrib_cents
      t.bigint  :candidate_self_fund_cents
      t.bigint  :debts_owed_cents
      t.string  :data_source, default: "fec_weball26"
      t.date    :coverage_through_date
      t.timestamps
    end

    add_index :official_finance_summaries, [:civic_representative_id, :cycle_year], unique: true, name: "idx_finance_summaries_on_rep_and_cycle"
    add_index :official_finance_summaries, :fec_candidate_id
  end
end
