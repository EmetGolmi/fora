class AddWikiTitleIncidentToSacredFireEntries < ActiveRecord::Migration[8.1]
  def change
    add_column :sacred_fire_entries, :wiki_title_incident, :string
  end
end
