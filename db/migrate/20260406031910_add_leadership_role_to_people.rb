class AddLeadershipRoleToPeople < ActiveRecord::Migration[8.1]
  def change
    add_column :people, :leadership_role, :string
  end
end
