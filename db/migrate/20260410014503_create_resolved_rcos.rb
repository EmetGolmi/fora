class CreateResolvedRcos < ActiveRecord::Migration[8.1]
  def up
    unless table_exists?(:resolved_rcos)
      create_table :resolved_rcos do |t|
        t.timestamps
      end
    end
    unless column_exists?(:resolved_rcos, :address_key)
      add_column :resolved_rcos, :address_key, :string, null: false
    end
    unless column_exists?(:resolved_rcos, :rco_data)
      add_column :resolved_rcos, :rco_data, :jsonb, null: false, default: []
    end
    unless column_exists?(:resolved_rcos, :fetched_at)
      add_column :resolved_rcos, :fetched_at, :datetime
    end
    unless index_exists?(:resolved_rcos, :address_key, unique: true)
      add_index :resolved_rcos, :address_key, unique: true
    end
  end

  def down
    drop_table :resolved_rcos, if_exists: true
  end
end
