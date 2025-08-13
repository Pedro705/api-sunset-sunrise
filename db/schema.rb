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

ActiveRecord::Schema[8.0].define(version: 2025_08_12_181148) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "historical_solar_records", force: :cascade do |t|
    t.bigint "location_id", null: false
    t.date "date", null: false
    t.datetime "sunrise"
    t.datetime "sunset"
    t.datetime "first_light"
    t.datetime "last_light"
    t.datetime "dawn"
    t.datetime "dusk"
    t.datetime "solar_noon"
    t.datetime "golden_hour"
    t.integer "day_length"
    t.string "timezone"
    t.integer "utc_offset"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date"], name: "index_historical_solar_records_on_date"
    t.index ["location_id", "date"], name: "index_historical_solar_records_on_location_id_and_date", unique: true
    t.index ["location_id"], name: "index_historical_solar_records_on_location_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "historical_solar_records", "locations"
end
