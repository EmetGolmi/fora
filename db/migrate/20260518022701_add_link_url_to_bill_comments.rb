class AddLinkUrlToBillComments < ActiveRecord::Migration[8.1]
  def change
    add_column :bill_comments, :link_url, :string
  end
end
