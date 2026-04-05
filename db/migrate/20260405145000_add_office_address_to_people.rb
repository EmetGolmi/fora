class AddOfficeAddressToPeople < ActiveRecord::Migration[8.1]
  def change
    add_column :people, :office_address, :string
  end
end
