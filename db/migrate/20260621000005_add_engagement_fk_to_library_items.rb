class AddEngagementFkToLibraryItems < ActiveRecord::Migration[8.1]
  def change
    add_foreign_key :library_items, :engagements, on_delete: :nullify
  end
end
