class AddCouncilFieldsToPeople < ActiveRecord::Migration[8.1]
  def change
    add_column :people, :district_number,              :integer  unless column_exists?(:people, :district_number)
    add_column :people, :district_name,                :string   unless column_exists?(:people, :district_name)
    add_column :people, :district_neighborhoods,       :text,    array: true, default: [] unless column_exists?(:people, :district_neighborhoods)
    add_column :people, :district_population,          :integer  unless column_exists?(:people, :district_population)
    add_column :people, :district_neighborhoods_count, :integer  unless column_exists?(:people, :district_neighborhoods_count)
    add_column :people, :district_median_income,       :integer  unless column_exists?(:people, :district_median_income)
    add_column :people, :district_owner_occupancy_pct, :integer  unless column_exists?(:people, :district_owner_occupancy_pct)
    add_column :people, :district_rco_count,           :integer  unless column_exists?(:people, :district_rco_count)
    add_column :people, :office_phone,                 :string   unless column_exists?(:people, :office_phone)
    add_column :people, :office_hours,                 :string   unless column_exists?(:people, :office_hours)
    add_column :people, :attendance_rate_pct,          :integer  unless column_exists?(:people, :attendance_rate_pct)
    add_column :people, :bills_introduced_count,       :integer  unless column_exists?(:people, :bills_introduced_count)
    add_column :people, :bills_passed_count,           :integer  unless column_exists?(:people, :bills_passed_count)
    add_column :people, :party_line_vote_pct,          :integer  unless column_exists?(:people, :party_line_vote_pct)
    add_column :people, :committees,                   :jsonb    unless column_exists?(:people, :committees)
    add_column :people, :issue_focus_areas,            :jsonb    unless column_exists?(:people, :issue_focus_areas)
    add_column :people, :recent_votes,                 :jsonb    unless column_exists?(:people, :recent_votes)
    add_column :people, :upcoming_events,              :jsonb    unless column_exists?(:people, :upcoming_events)
  end
end
