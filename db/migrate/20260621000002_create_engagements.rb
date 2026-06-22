class CreateEngagements < ActiveRecord::Migration[8.1]
  def change
    create_table :engagements do |t|
      t.string  :title,       null: false
      t.integer :status,      default: 0, null: false  # 0=current, 1=completed
      t.string  :case_number                            # YYYYMMDD-NNN, auto-set in model
      t.string  :profession                             # e.g. "home_inspector"
      t.text    :notes

      t.timestamps
    end

    add_index :engagements, :case_number, unique: true, where: "case_number IS NOT NULL"
    add_index :engagements, :status
  end
end
