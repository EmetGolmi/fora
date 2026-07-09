class AddWikiTitleToSacredFireEntries < ActiveRecord::Migration[8.1]
  def change
    add_column :sacred_fire_entries, :wiki_title, :string
  end
end
