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

ActiveRecord::Schema[8.1].define(version: 2026_04_05_190000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "civic_bills", force: :cascade do |t|
    t.string "bill_stage", default: "introduced"
    t.datetime "created_at", null: false
    t.string "external_id", null: false
    t.string "full_text_url"
    t.string "identifier"
    t.string "jurisdiction", null: false
    t.jsonb "raw_data"
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
    t.string "first_name"
    t.string "full_name"
    t.jsonb "issue_focus_areas"
    t.string "last_name"
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

  create_table "resolved_addresses", force: :cascade do |t|
    t.string "address", null: false
    t.datetime "created_at", null: false
    t.string "job_id", null: false
    t.text "result_json", null: false
    t.datetime "updated_at", null: false
    t.index ["address"], name: "index_resolved_addresses_on_address", unique: true
    t.index ["job_id"], name: "index_resolved_addresses_on_job_id"
  end

  add_foreign_key "official_finance_summaries", "civic_representatives"
end
