class CreateOnThisDayEntries < ActiveRecord::Migration[8.1]
  def up
    enable_extension "pgcrypto" unless extension_enabled?("pgcrypto")

    create_table :on_this_day_entries, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.integer :month,             null: false
      t.integer :day,               null: false
      t.integer :year
      t.string  :entry_type,        null: false
      t.string  :title,             null: false
      t.text    :body,              null: false
      t.text    :quote
      t.string  :quote_attribution
      t.string  :neighborhood
      t.boolean :is_featured,       default: false, null: false
      t.jsonb   :sources,           default: [],    null: false
      t.string  :verified,          default: "confirmed", null: false
      t.uuid    :jurisdiction_id
      t.timestamps
    end

    add_index :on_this_day_entries, [:month, :day]
    add_index :on_this_day_entries, :jurisdiction_id
  end

  def down
    drop_table :on_this_day_entries
  end
end
