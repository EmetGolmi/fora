class CreateTempleDomains < ActiveRecord::Migration[8.1]
  def change
    create_table :temple_domains do |t|
      t.string  :name,     null: false
      t.string  :slug,     null: false
      t.string  :icon,     null: false
      t.integer :position, null: false, default: 0
      t.timestamps
    end
    add_index :temple_domains, :slug, unique: true
  end
end
