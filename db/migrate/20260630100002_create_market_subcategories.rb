class CreateMarketSubcategories < ActiveRecord::Migration[8.1]
  def change
    create_table :market_subcategories do |t|
      t.references :market_domain, null: false, foreign_key: true
      t.string  :name,     null: false
      t.string  :slug,     null: false
      t.integer :position, null: false, default: 0
      t.timestamps
    end
    add_index :market_subcategories, [:market_domain_id, :slug], unique: true
  end
end
