class CreateNeighborhoodIssues < ActiveRecord::Migration[8.1]
  def change
    unless table_exists?(:neighborhood_issues)
      create_table :neighborhood_issues do |t|
        t.string  :rco_slug,          null: false
        t.text    :body,              null: false
        t.string  :perspective_type,  null: false, default: "empathy"
        t.string  :author_name
        t.string  :author_email
        t.string  :location_description
        t.boolean :anonymous,         default: false
        t.integer :concurrence_count, default: 0
        t.boolean :ccra_alerted,      default: false
        t.integer :alert_threshold,   default: 10
        t.timestamps
      end

      add_index :neighborhood_issues, :rco_slug
      add_index :neighborhood_issues, :ccra_alerted
    end

    unless table_exists?(:issue_responses)
      create_table :issue_responses do |t|
        t.references :neighborhood_issue, null: false, foreign_key: true
        t.text    :body,             null: false
        t.string  :perspective_type, null: false, default: "empathy"
        t.string  :author_name
        t.string  :author_email
        t.boolean :anonymous,        default: false
        t.boolean :official,         default: false
        t.integer :concurrence_count, default: 0
        t.timestamps
      end
    end

    unless table_exists?(:issue_concurrences)
      create_table :issue_concurrences do |t|
        t.references :neighborhood_issue, null: false, foreign_key: true
        t.string :session_token, null: false
        t.timestamps
      end

      add_index :issue_concurrences,
                [:neighborhood_issue_id, :session_token],
                unique: true,
                name: "index_issue_concurrences_on_issue_and_token"
    end
  end
end
