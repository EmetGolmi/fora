class CreateDefinitions < ActiveRecord::Migration[8.1]
  def change
    create_table :definitions do |t|
      t.string  :term,          null: false
      t.text    :plain_meaning, null: false
      t.integer :context,       null: false
      t.string  :source_url

      t.timestamps
    end

    add_index :definitions, [:term, :context], unique: true
  end
end
