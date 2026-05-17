class CreateBillComments < ActiveRecord::Migration[8.1]
  def change
    unless table_exists?(:bill_comments)
      create_table :bill_comments do |t|
        t.bigint  :civic_bill_id,     null: false
        t.string  :stance,            null: false, default: "undecided"
        t.string  :perspective_type,  null: false
        t.text    :body,              null: false
        t.string  :occupation
        t.boolean :anonymous,         null: false, default: false
        t.string  :photo_url
        t.string  :session_token,     null: false
        t.uuid    :jurisdiction_id
        t.timestamps
      end

      add_foreign_key :bill_comments, :civic_bills
      add_index :bill_comments, :civic_bill_id
      add_index :bill_comments, :stance
      add_index :bill_comments, :session_token
    end
  end
end
