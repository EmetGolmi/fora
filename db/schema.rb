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

ActiveRecord::Schema[8.1].define(version: 2026_06_21_000006) do
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

  create_table "civic_profiles", force: :cascade do |t|
    t.boolean "accepting_clients", default: false, null: false
    t.string "address_city"
    t.string "address_line1"
    t.string "address_state"
    t.text "bio"
    t.text "care_tags", default: [], array: true
    t.datetime "created_at", null: false
    t.string "display_name"
    t.string "faith_branch"
    t.string "faith_tradition"
    t.text "grow_chips", default: [], array: true
    t.boolean "has_entity"
    t.string "naics_code"
    t.boolean "onboarding_complete", default: false, null: false
    t.integer "onboarding_step", default: 0, null: false
    t.string "place_label"
    t.string "provider_headline"
    t.boolean "provider_mode", default: false, null: false
    t.boolean "residency_verified", default: false, null: false
    t.string "residency_verify_method"
    t.string "resolve_job_id"
    t.boolean "service_active", default: false, null: false
    t.jsonb "service_area"
    t.text "service_summary"
    t.boolean "service_veteran", default: false, null: false
    t.boolean "show_photo", default: false, null: false
    t.integer "temple_scale_balance"
    t.integer "temple_scale_purpose"
    t.integer "temple_scale_reason"
    t.integer "temple_scale_tradition"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_civic_profiles_on_user_id"
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

  create_table "compliance_obligations", force: :cascade do |t|
    t.integer "cadence", default: 0, null: false
    t.datetime "created_at", null: false
    t.bigint "credential_id"
    t.string "label", null: false
    t.date "next_due_at", null: false
    t.integer "obligation_type", default: 0, null: false
    t.bigint "profile_id", null: false
    t.integer "reminder_lead_days", default: 30, null: false
    t.bigint "source_step_id"
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["credential_id"], name: "index_compliance_obligations_on_credential_id"
    t.index ["profile_id"], name: "index_compliance_obligations_on_profile_id"
    t.index ["source_step_id"], name: "index_compliance_obligations_on_source_step_id"
  end

  create_table "definitions", force: :cascade do |t|
    t.integer "context", null: false
    t.datetime "created_at", null: false
    t.text "plain_meaning", null: false
    t.string "source_url"
    t.string "term", null: false
    t.datetime "updated_at", null: false
    t.index ["term", "context"], name: "index_definitions_on_term_and_context", unique: true
  end

  create_table "document_templates", force: :cascade do |t|
    t.integer "authored_by", default: 0, null: false
    t.text "body_template", null: false
    t.datetime "created_at", null: false
    t.integer "doc_kind", null: false
    t.bigint "jurisdiction_id"
    t.text "legal_disclaimer", null: false
    t.string "name", null: false
    t.jsonb "placeholders", default: [], null: false
    t.datetime "updated_at", null: false
    t.integer "version", default: 1, null: false
    t.index ["jurisdiction_id"], name: "index_document_templates_on_jurisdiction_id"
  end

  create_table "engagement_participants", force: :cascade do |t|
    t.bigint "civic_profile_id", null: false
    t.datetime "created_at", null: false
    t.bigint "engagement_id", null: false
    t.string "role", null: false
    t.datetime "updated_at", null: false
    t.index ["civic_profile_id"], name: "index_engagement_participants_on_civic_profile_id"
    t.index ["engagement_id", "civic_profile_id", "role"], name: "idx_eng_participants_unique", unique: true
    t.index ["engagement_id"], name: "index_engagement_participants_on_engagement_id"
  end

  create_table "engagements", force: :cascade do |t|
    t.string "case_number"
    t.datetime "created_at", null: false
    t.text "notes"
    t.string "profession"
    t.integer "status", default: 0, null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["case_number"], name: "index_engagements_on_case_number", unique: true, where: "(case_number IS NOT NULL)"
    t.index ["status"], name: "index_engagements_on_status"
  end

  create_table "formation_steps", force: :cascade do |t|
    t.jsonb "action_links", default: [], null: false
    t.text "body", null: false
    t.boolean "community_refined", default: false, null: false
    t.string "cost_range"
    t.datetime "created_at", null: false
    t.integer "display_order", default: 0, null: false
    t.string "naics_code"
    t.string "phase", null: false
    t.integer "requirement", default: 0, null: false
    t.string "save_as"
    t.bigint "supersedes_id"
    t.string "title", null: false
    t.bigint "track_id", null: false
    t.datetime "updated_at", null: false
    t.index ["supersedes_id"], name: "index_formation_steps_on_supersedes_id"
    t.index ["track_id"], name: "index_formation_steps_on_track_id"
  end

  create_table "formation_tracks", force: :cascade do |t|
    t.integer "authored_by", default: 0, null: false
    t.datetime "created_at", null: false
    t.integer "entity_type", default: 1, null: false
    t.boolean "is_published", default: false, null: false
    t.bigint "jurisdiction_id"
    t.integer "max_cost_cents"
    t.integer "min_cost_cents"
    t.string "name", null: false
    t.string "profession"
    t.text "summary"
    t.datetime "updated_at", null: false
    t.integer "version", default: 1, null: false
    t.index ["jurisdiction_id"], name: "index_formation_tracks_on_jurisdiction_id"
  end

  create_table "ijdb_comments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "author_name"
    t.bigint "author_user_id"
    t.text "body", null: false
    t.string "city", null: false
    t.string "country", default: "usa"
    t.datetime "created_at", null: false
    t.uuid "ijdb_entry_id"
    t.index ["city", "country"], name: "index_ijdb_comments_on_city_and_country"
    t.index ["ijdb_entry_id"], name: "index_ijdb_comments_on_ijdb_entry_id"
  end

  create_table "ijdb_entries", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "amount_high_cents"
    t.bigint "amount_low_cents"
    t.string "amount_unit", default: "usd"
    t.string "category", null: false
    t.string "city"
    t.string "confidence"
    t.string "contributor_attribution"
    t.bigint "contributor_id"
    t.string "country", default: "usa"
    t.datetime "created_at", null: false
    t.integer "date_range_end"
    t.integer "date_range_start"
    t.text "description"
    t.integer "display_order"
    t.string "entity_name"
    t.boolean "foia_candidate", default: false
    t.string "foia_topic_template"
    t.string "scope"
    t.date "source_date"
    t.string "source_title"
    t.string "source_url"
    t.string "subcategory"
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.datetime "verified_at"
    t.string "verified_by"
    t.index ["category"], name: "index_ijdb_entries_on_category"
    t.index ["city", "country"], name: "index_ijdb_entries_on_city_and_country"
    t.index ["confidence"], name: "index_ijdb_entries_on_confidence"
    t.index ["display_order"], name: "index_ijdb_entries_on_display_order"
    t.index ["foia_candidate"], name: "index_ijdb_entries_on_foia_candidate"
  end

  create_table "ijdb_foia_requests", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "agency"
    t.string "city"
    t.datetime "created_at", null: false
    t.date "filed_at"
    t.uuid "ijdb_entry_id"
    t.text "letter_text"
    t.string "requester_name"
    t.date "response_received_at"
    t.text "response_summary"
    t.string "status", default: "drafted"
    t.string "topic_key"
    t.index ["city"], name: "index_ijdb_foia_requests_on_city"
    t.index ["ijdb_entry_id"], name: "index_ijdb_foia_requests_on_ijdb_entry_id"
    t.index ["status"], name: "index_ijdb_foia_requests_on_status"
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

  create_table "library_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.bigint "engagement_id"
    t.string "file_url"
    t.integer "item_type", null: false
    t.bigint "owner_profile_id", null: false
    t.integer "source", null: false
    t.string "source_url"
    t.string "tags", default: [], array: true
    t.string "thumbnail_url"
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.integer "visibility", null: false
    t.index ["engagement_id"], name: "index_library_items_on_engagement_id"
    t.index ["owner_profile_id"], name: "index_library_items_on_owner_profile_id"
    t.index ["tags"], name: "index_library_items_on_tags", using: :gin
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

  create_table "provider_capabilities", force: :cascade do |t|
    t.bigint "civic_profile_id", null: false
    t.datetime "created_at", null: false
    t.string "naics_code"
    t.string "profession", null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["civic_profile_id", "profession"], name: "index_provider_capabilities_on_civic_profile_id_and_profession", unique: true
    t.index ["civic_profile_id"], name: "index_provider_capabilities_on_civic_profile_id"
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

  create_table "user_formation_progress", force: :cascade do |t|
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.bigint "document_id"
    t.text "notes"
    t.integer "status", default: 0, null: false
    t.bigint "step_id", null: false
    t.bigint "track_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["document_id"], name: "index_user_formation_progress_on_document_id"
    t.index ["step_id"], name: "index_user_formation_progress_on_step_id"
    t.index ["track_id"], name: "index_user_formation_progress_on_track_id"
    t.index ["user_id", "step_id"], name: "index_user_formation_progress_on_user_id_and_step_id", unique: true
    t.index ["user_id"], name: "index_user_formation_progress_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "handle", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.boolean "verified", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["handle"], name: "index_users_on_handle", unique: true
  end

  add_foreign_key "bill_comments", "civic_bills"
  add_foreign_key "civic_profiles", "users"
  add_foreign_key "compliance_obligations", "civic_profiles", column: "profile_id", on_delete: :cascade
  add_foreign_key "compliance_obligations", "formation_steps", column: "source_step_id", on_delete: :nullify
  add_foreign_key "engagement_participants", "civic_profiles"
  add_foreign_key "engagement_participants", "engagements"
  add_foreign_key "formation_steps", "formation_tracks", column: "track_id", on_delete: :cascade
  add_foreign_key "ijdb_comments", "ijdb_entries"
  add_foreign_key "ijdb_foia_requests", "ijdb_entries"
  add_foreign_key "issue_concurrences", "neighborhood_issues"
  add_foreign_key "issue_responses", "neighborhood_issues"
  add_foreign_key "library_items", "civic_profiles", column: "owner_profile_id", on_delete: :cascade
  add_foreign_key "library_items", "engagements", on_delete: :nullify
  add_foreign_key "official_finance_summaries", "civic_representatives"
  add_foreign_key "provider_capabilities", "civic_profiles"
  add_foreign_key "user_formation_progress", "formation_steps", column: "step_id"
  add_foreign_key "user_formation_progress", "formation_tracks", column: "track_id"
  add_foreign_key "user_formation_progress", "library_items", column: "document_id", on_delete: :nullify
  add_foreign_key "user_formation_progress", "users"
end
