class AddProfileColumnsToPeople < ActiveRecord::Migration[8.1]
  def change
    add_column :people, :full_name,     :string
    add_column :people, :first_name,    :string
    add_column :people, :last_name,     :string
    add_column :people, :photo_url,     :string
    add_column :people, :office_title,  :string
    add_column :people, :term_start,    :date
    add_column :people, :term_end,      :date
    add_column :people, :website_url,   :string
    add_column :people, :contact_url,   :string
    add_column :people, :twitter_handle, :string
    add_column :people, :data_as_of,    :string
  end
end
