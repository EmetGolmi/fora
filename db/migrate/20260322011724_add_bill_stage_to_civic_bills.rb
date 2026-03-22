class AddBillStageToCivicBills < ActiveRecord::Migration[8.1]
  def change
    add_column :civic_bills, :bill_stage, :string, default: "introduced"
    add_index  :civic_bills, :bill_stage
  end
end
