class CreateMarketDomains < ActiveRecord::Migration[8.1]
  def change
    create_table :market_domains do |t|
      t.string  :name,     null: false
      t.string  :slug,     null: false
      t.string  :icon,     null: false
      t.integer :position, null: false, default: 0
      t.timestamps
    end
    add_index :market_domains, :slug, unique: true
  end
end
