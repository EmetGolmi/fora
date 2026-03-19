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

ActiveRecord::Schema[8.1].define(version: 2026_03_19_011549) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "civic_bills", force: :cascade do |t|
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
    t.index ["jurisdiction"], name: "index_civic_bills_on_jurisdiction"
    t.index ["source", "external_id"], name: "index_civic_bills_on_source_and_external_id", unique: true
    t.index ["status_date"], name: "index_civic_bills_on_status_date"
  end

  create_table "civic_representatives", force: :cascade do |t|
    t.jsonb "contact", default: {}
    t.datetime "created_at", null: false
    t.string "external_id"
    t.string "jurisdiction"
    t.string "name", null: false
    t.string "ocd_division_id"
    t.string "office"
    t.string "party"
    t.string "source"
    t.datetime "updated_at", null: false
    t.index ["ocd_division_id"], name: "index_civic_representatives_on_ocd_division_id"
  end
end
