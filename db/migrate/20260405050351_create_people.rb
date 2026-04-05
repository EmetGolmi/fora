class CreatePeople < ActiveRecord::Migration[8.1]
  def change
    create_table :people do |t|
      # Identity
      t.string  :name,             null: false
      t.string  :slug,             null: false
      t.string  :office_type                        # 'legislator' | 'governor' | 'lt_governor' | 'attorney_general' | 'mayor'
      t.string  :state,            default: "PA"
      t.string  :party

      # Approval
      t.integer :approval_rating                    # percentage, as of approval_source date
      t.string  :approval_source                    # e.g. "Franklin & Marshall · Feb 2026"

      # Budget
      t.decimal :budget_total_billions, precision: 8, scale: 2
      t.jsonb   :budget_breakdown,      default: {} # { education: 35, health: 30, ... }

      # Legislative record
      t.integer :veto_count
      t.integer :bills_signed_count

      # Lt. Governor (for governor profiles)
      t.string  :lt_governor_name
      t.string  :lt_governor_initials

      # Divided government
      t.boolean :divided_government
      t.string  :divided_gov_note

      # Executive activity (JSONB arrays)
      t.jsonb   :policy_priorities, default: []     # [{ name:, level:, color: }, ...]
      t.jsonb   :executive_orders,  default: []     # [{ number:, title:, category:, date: }, ...]
      t.jsonb   :veto_record,       default: []     # [{ bill:, title:, note:, date:, outcome: }, ...]

      t.timestamps
    end

    add_index :people, :slug,        unique: true
    add_index :people, :office_type
  end
end
