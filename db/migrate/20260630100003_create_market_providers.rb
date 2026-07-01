class CreateMarketProviders < ActiveRecord::Migration[8.1]
  def change
    create_table :market_providers do |t|
      t.references :market_subcategory, null: false, foreign_key: true
      t.string  :name,             null: false
      t.string  :handle
      t.integer :provider_type,    null: false, default: 0
      t.text    :description
      t.decimal :latitude,         precision: 10, scale: 6
      t.decimal :longitude,        precision: 10, scale: 6
      t.boolean :is_mobile,        default: false
      t.jsonb   :service_territory
      t.string  :address
      t.string  :neighborhood
      t.string  :city
      t.string  :state
      t.string  :zip
      t.string  :phone
      t.string  :website
      t.string  :license_number
      t.boolean :license_verified, default: false
      t.decimal :rating_cache,     precision: 3, scale: 1
      t.integer :review_count,     default: 0
      t.boolean :is_active,        default: true
      t.timestamps
    end
  end
end
