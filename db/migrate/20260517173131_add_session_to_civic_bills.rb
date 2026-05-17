class AddSessionToCivicBills < ActiveRecord::Migration[8.1]
  def change
    add_column :civic_bills, :session_identifier, :string
  end
end
