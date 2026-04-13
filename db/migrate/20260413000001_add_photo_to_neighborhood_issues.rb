class AddPhotoToNeighborhoodIssues < ActiveRecord::Migration[7.2]
  def change
    add_column :neighborhood_issues, :photo_data,     :text   unless column_exists?(:neighborhood_issues, :photo_data)
    add_column :neighborhood_issues, :photo_url,      :string unless column_exists?(:neighborhood_issues, :photo_url)
    add_column :neighborhood_issues, :photo_filename, :string unless column_exists?(:neighborhood_issues, :photo_filename)
    add_column :issue_responses,     :photo_data,     :text   unless column_exists?(:issue_responses, :photo_data)
    add_column :issue_responses,     :photo_url,      :string unless column_exists?(:issue_responses, :photo_url)
    add_column :issue_responses,     :photo_filename, :string unless column_exists?(:issue_responses, :photo_filename)
  end
end
