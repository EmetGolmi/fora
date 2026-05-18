# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_05_18_195459) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pgcrypto"

  create_table "bill_comments", force: :cascade do |t|
    t.boolean "anonymous", default: false, null: false
    t.text "body", null: false
    t.bigint "civic_bill_id", null: false
    t.datetime "created_at", null: false
    t.uuid "jurisdiction_id"
    t.string "link_url"
    t.string "occupation"
    t.string "perspective_type", null: false
    t.string "photo_url"
    t.string "session_token", null: false
    t.string "stance", default: "undecided", null: false
    t.datetime "updated_at", null: false
    t.index ["civic_bill_id"], name: "index_bill_comments_on_civic_bill_id"
    t.index ["session_token"], name: "index_bill_comments_on_session_token"
    t.index ["stance"], name: "index_bill_comments_on_stance"
  end

  create_table "civic_bills", force: :cascade do |t|
    t.string "bill_stage", default: "introduced"
    t.datetime "created_at", null: false
    t.string "external_id", null: false
    t.string "full_text_url"
    t.string "identifier"
    t.string "jurisdiction", null: false
    t.jsonb "raw_data"
    t.string "session_identifier"
    t.string "source", null: false
    t.jsonb "sponsors", default: []
    t.string "status"
    t.date "status_date"
    t.jsonb "subjects", default: []
    t.text "summary"
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.jsonb "votes", default: []
    t.index ["bill_stage"], name: "index_civic_bills_on_bill_stage"
    t.index ["jurisdiction"], name: "index_civic_bills_on_jurisdiction"
    t.index ["source", "external_id"], name: "index_civic_bills_on_source_and_external_id", unique: true
    t.index ["status_date"], name: "index_civic_bills_on_status_date"
  end

  create_table "civic_representatives", force: :cascade do |t|
    t.jsonb "contact", default: {}
    t.datetime "created_at", null: false
    t.string "external_id"
    t.jsonb "external_ids", default: {}
    t.string "jurisdiction"
    t.string "name", null: false
    t.string "ocd_division_id"
    t.string "office"
    t.string "party"
    t.string "source"
    t.datetime "updated_at", null: false
    t.index ["external_ids"], name: "index_civic_representatives_on_external_ids", using: :gin
    t.index ["ocd_division_id"], name: "index_civic_representatives_on_ocd_division_id"
  end

  create_table "issue_concurrences", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "neighborhood_issue_id", null: false
    t.string "session_token", null: false
    t.datetime "updated_at", null: false
    t.index ["neighborhood_issue_id", "session_token"], name: "index_issue_concurrences_on_issue_and_token", unique: true
    t.index ["neighborhood_issue_id"], name: "index_issue_concurrences_on_neighborhood_issue_id"
  end

  create_table "issue_responses", force: :cascade do |t|
    t.boolean "anonymous", default: false
    t.string "author_email"
    t.string "author_name"
    t.text "body", null: false
    t.integer "concurrence_count", default: 0
    t.datetime "created_at", null: false
    t.bigint "neighborhood_issue_id", null: false
    t.boolean "official", default: false
    t.string "perspective_type", default: "empathy", null: false
    t.text "photo_data"
    t.string "photo_filename"
    t.string "photo_url"
    t.datetime "updated_at", null: false
    t.index ["neighborhood_issue_id"], name: "index_issue_responses_on_neighborhood_issue_id"
  end

  create_table "neighborhood_issues", force: :cascade do |t|
    t.integer "alert_threshold", default: 10
    t.boolean "anonymous", default: false
    t.string "author_email"
    t.string "author_name"
    t.text "body", null: false
    t.boolean "ccra_alerted", default: false
    t.integer "concurrence_count", default: 0
    t.datetime "created_at", null: false
    t.string "location_description"
    t.string "perspective_type", default: "empathy", null: false
    t.text "photo_data"
    t.string "photo_filename"
    t.string "photo_url"
    t.string "rco_slug", null: false
    t.datetime "updated_at", null: false
    t.index ["ccra_alerted"], name: "index_neighborhood_issues_on_ccra_alerted"
    t.index ["rco_slug"], name: "index_neighborhood_issues_on_rco_slug"
  end

  create_table "official_finance_summaries", force: :cascade do |t|
    t.bigint "candidate_self_fund_cents"
    t.bigint "cash_on_hand_cents"
    t.bigint "civic_representative_id", null: false
    t.date "coverage_through_date"
    t.datetime "created_at", null: false
    t.integer "cycle_year", null: false
    t.string "data_source", default: "fec_weball26"
    t.bigint "debts_owed_cents"
    t.string "fec_candidate_id", null: false
    t.bigint "individual_contrib_cents"
    t.bigint "pac_contrib_cents"
    t.bigint "total_raised_cents"
    t.bigint "total_spent_cents"
    t.datetime "updated_at", null: false
    t.index ["civic_representative_id", "cycle_year"], name: "idx_finance_summaries_on_rep_and_cycle", unique: true
    t.index ["civic_representative_id"], name: "index_official_finance_summaries_on_civic_representative_id"
    t.index ["fec_candidate_id"], name: "index_official_finance_summaries_on_fec_candidate_id"
  end

  create_table "on_this_day_entries", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.integer "day", null: false
    t.string "entry_type", null: false
    t.boolean "is_featured", default: false, null: false
    t.uuid "jurisdiction_id"
    t.integer "month", null: false
    t.string "neighborhood"
    t.text "quote"
    t.string "quote_attribution"
    t.jsonb "sources", default: [], null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.string "verified", default: "confirmed", null: false
    t.integer "year"
    t.index ["jurisdiction_id"], name: "index_on_this_day_entries_on_jurisdiction_id"
    t.index ["month", "day"], name: "index_on_this_day_entries_on_month_and_day"
  end

  create_table "people", force: :cascade do |t|
    t.integer "approval_rating"
    t.string "approval_source"
    t.integer "attendance_rate_pct"
    t.integer "bills_introduced_count"
    t.integer "bills_passed_count"
    t.integer "bills_signed_count"
    t.jsonb "budget_breakdown", default: {}
    t.decimal "budget_total_billions", precision: 8, scale: 2
    t.jsonb "committees"
    t.string "contact_url"
    t.datetime "created_at", null: false
    t.string "data_as_of"
    t.integer "district_median_income"
    t.string "district_name"
    t.text "district_neighborhoods", default: [], array: true
    t.integer "district_neighborhoods_count"
    t.integer "district_number"
    t.integer "district_owner_occupancy_pct"
    t.integer "district_population"
    t.integer "district_rco_count"
    t.string "divided_gov_note"
    t.boolean "divided_government"
    t.jsonb "executive_orders", default: []
    t.jsonb "extra_data", default: {}
    t.string "first_name"
    t.string "full_name"
    t.jsonb "issue_focus_areas"
    t.string "last_name"
    t.string "leadership_role"
    t.string "lt_governor_initials"
    t.string "lt_governor_name"
    t.string "name", null: false
    t.string "office_address"
    t.string "office_hours"
    t.string "office_phone"
    t.string "office_title"
    t.string "office_type"
    t.string "party"
    t.integer "party_line_vote_pct"
    t.string "photo_url"
    t.jsonb "policy_priorities", default: []
    t.jsonb "recent_votes"
    t.string "slug", null: false
    t.string "state", default: "PA"
    t.date "term_end"
    t.date "term_start"
    t.string "twitter_handle"
    t.jsonb "upcoming_events"
    t.datetime "updated_at", null: false
    t.integer "veto_count"
    t.jsonb "veto_record", default: []
    t.string "website_url"
    t.index ["office_type"], name: "index_people_on_office_type"
    t.index ["slug"], name: "index_people_on_slug", unique: true
  end

  create_table "pre_ballots", force: :cascade do |t|
    t.string "ballot_q1"
    t.string "ballot_q2"
    t.datetime "created_at", null: false
    t.string "division", null: false
    t.string "election_slug", default: "pa_primary_20260519", null: false
    t.string "governor"
    t.string "lt_governor"
    t.string "pa_state_rep"
    t.string "session_token_hash", null: false
    t.datetime "updated_at", null: false
    t.string "us_rep"
    t.string "ward", null: false
    t.string "zip_code"
    t.index ["election_slug"], name: "idx_preballot_election"
    t.index ["session_token_hash", "election_slug"], name: "idx_preballot_session_election", unique: true
    t.index ["ward", "division", "election_slug"], name: "idx_preballot_geography"
  end

  create_table "resolved_addresses", force: :cascade do |t|
    t.string "address", null: false
    t.datetime "created_at", null: false
    t.string "job_id", null: false
    t.text "result_json", null: false
    t.datetime "updated_at", null: false
    t.index ["address"], name: "index_resolved_addresses_on_address", unique: true
    t.index ["job_id"], name: "index_resolved_addresses_on_job_id"
  end

  create_table "resolved_rcos", force: :cascade do |t|
    t.string "address_key", null: false
    t.datetime "created_at", null: false
    t.datetime "fetched_at"
    t.jsonb "rco_data", default: [], null: false
    t.datetime "updated_at", null: false
    t.index ["address_key"], name: "index_resolved_rcos_on_address_key", unique: true
  end

  add_foreign_key "bill_comments", "civic_bills"
  add_foreign_key "issue_concurrences", "neighborhood_issues"
  add_foreign_key "issue_responses", "neighborhood_issues"
  add_foreign_key "official_finance_summaries", "civic_representatives"
end
