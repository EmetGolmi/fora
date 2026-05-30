class CreateIjdbEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :ijdb_entries, id: :uuid do |t|
      t.string  :city,                    null: false
      t.string  :country,                 default: "usa"
      t.string  :category,                null: false
      t.string  :subcategory
      t.string  :title,                   null: false
      t.text    :description
      t.bigint  :amount_low_cents         # null = uncalculated / classified / gap
      t.bigint  :amount_high_cents
      t.string  :amount_unit,             default: "usd"   # usd | lives | incidents
      t.string  :confidence               # documented | estimated | partial | classified | gap
      t.string  :scope                    # local | federal_share | private | classified
      t.integer :date_range_start
      t.integer :date_range_end
      t.string  :entity_name
      t.string  :source_url
      t.string  :source_title
      t.date    :source_date
      t.boolean :foia_candidate,          default: false
      t.string  :foia_topic_template
      t.bigint  :contributor_id           # no FK — User model not yet in schema
      t.string  :contributor_attribution
      t.datetime :verified_at
      t.string   :verified_by
      t.integer  :display_order
      t.timestamps
    end

    add_index :ijdb_entries, [:city, :country]
    add_index :ijdb_entries, :category
    add_index :ijdb_entries, :confidence
    add_index :ijdb_entries, :foia_candidate
    add_index :ijdb_entries, :display_order
  end
end
