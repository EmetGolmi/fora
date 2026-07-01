class CreateMarketTempleItems < ActiveRecord::Migration[8.1]
  def change
    create_table :market_temple_items do |t|
      t.references :market_subcategory, null: true, foreign_key: true
      t.references :market_domain,      null: true, foreign_key: true
      t.integer :item_type,  null: false, default: 0
      t.string  :title,      null: false
      t.text    :body
      t.string  :source_url
      t.boolean :is_active,  default: true
      t.integer :position,   default: 0
      t.timestamps
    end
  end
end
