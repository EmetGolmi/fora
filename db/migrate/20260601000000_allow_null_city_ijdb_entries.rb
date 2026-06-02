class AllowNullCityIjdbEntries < ActiveRecord::Migration[8.0]
  def change
    change_column_null :ijdb_entries, :city, true
  end
end
