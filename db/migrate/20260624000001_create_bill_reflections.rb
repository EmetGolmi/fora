class CreateBillReflections < ActiveRecord::Migration[8.1]
  def change
    create_table :bill_reflections do |t|
      t.references :civic_profile, null: false, foreign_key: true
      t.references :civic_bill,    null: false, foreign_key: true
      t.jsonb      :feeling_tags,  null: false, default: []
      t.text       :reaction_note
      t.text       :steelman_note
      t.timestamps
    end

    add_index :bill_reflections, [:civic_profile_id, :civic_bill_id],
              unique: true,
              name: "idx_bill_reflections_profile_bill"
  end
end
