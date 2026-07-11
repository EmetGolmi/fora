class CreateForumComments < ActiveRecord::Migration[8.1]
  def change
    create_table :forum_comments do |t|
      t.string  :bill_num, null: false
      t.text    :body,     null: false
      t.integer :user_id
      t.string  :handle
      t.timestamps
    end
    add_index :forum_comments, :bill_num
    add_index :forum_comments, :user_id
  end
end
