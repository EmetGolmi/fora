class CreateLibraryItems < ActiveRecord::Migration[8.1]
  def change
    create_table :library_items do |t|
      t.string  :title,         null: false
      t.text    :description
      t.string  :source_url
      t.string  :file_url
      t.string  :thumbnail_url
      t.integer :item_type,     null: false
      t.integer :source,        null: false
      t.integer :visibility,    null: false
      # owner_profile_id → civic_profiles (column name differs from table name, hence to_table:)
      t.references :owner_profile, null: false, index: true,
                   foreign_key: { to_table: :civic_profiles, on_delete: :cascade }
      # engagement_id — plain nullable bigint, no FK yet (engagements arrives later)
      t.bigint  :engagement_id
      # PostgreSQL array — cannot be expressed in generator field list, hand-written here
      t.string  :tags, array: true, default: []

      t.timestamps
    end

    add_index :library_items, :engagement_id
    add_index :library_items, :tags, using: :gin
  end
end
