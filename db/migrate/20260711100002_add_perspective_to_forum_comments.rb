class AddPerspectiveToForumComments < ActiveRecord::Migration[8.1]
  def change
    add_column :forum_comments, :perspective_type, :string, default: "general", null: false
    add_column :forum_comments, :social_url, :string
    add_index  :forum_comments, :perspective_type
  end
end
