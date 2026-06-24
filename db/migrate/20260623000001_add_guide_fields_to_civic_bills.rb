class AddGuideFieldsToCivicBills < ActiveRecord::Migration[8.1]
  def change
    # Human-seeded plain language content (overrides AI cache when present)
    add_column :civic_bills, :plain_summary, :text
    add_column :civic_bills, :effects,       :jsonb, default: []

    # Sit / Study / Share guide content
    add_column :civic_bills, :sit_for,      :text
    add_column :civic_bills, :sit_against,  :text
    add_column :civic_bills, :study_facts,  :jsonb, default: []

    # Guard: only render the full guide for seeded bills; others get a graceful placeholder
    add_column :civic_bills, :guide_seeded, :boolean, default: false, null: false
  end
end
