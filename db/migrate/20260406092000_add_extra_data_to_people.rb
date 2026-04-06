class AddExtraDataToPeople < ActiveRecord::Migration[8.1]
  def change
    add_column :people, :extra_data, :jsonb, default: {}
  end
end
