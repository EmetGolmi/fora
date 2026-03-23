class CreateResolvedAddresses < ActiveRecord::Migration[8.1]
  def change
    create_table :resolved_addresses do |t|
      t.string :address,     null: false
      t.string :job_id,      null: false
      t.text   :result_json, null: false
      t.timestamps
    end

    add_index :resolved_addresses, :address, unique: true
    add_index :resolved_addresses, :job_id
  end
end
