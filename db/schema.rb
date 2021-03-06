# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150526034254) do

  create_table "data", force: :cascade do |t|
    t.string   "windDirection"
    t.float    "windSpeed"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.float    "rainSince9am"
    t.string   "source"
    t.string   "obsTime"
    t.float    "temp"
    t.float    "dewPoint"
    t.float    "wetBulb"
    t.float    "humidity"
    t.float    "pressure"
    t.float    "windBearing"
    t.float    "precipIntense"
    t.float    "precipProb"
    t.string   "condition"
    t.float    "cloudCover"
    t.integer  "location_id"
  end

  add_index "data", ["location_id"], name: "index_data_on_location_id"

  create_table "locations", force: :cascade do |t|
    t.string   "station"
    t.float    "lat"
    t.float    "lon"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "postcode_id"
  end

  add_index "locations", ["postcode_id"], name: "index_locations_on_postcode_id"

  create_table "postcodes", force: :cascade do |t|
    t.integer  "postcode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "predictions", force: :cascade do |t|
    t.float    "rainValue"
    t.float    "rainProb"
    t.float    "tempValue"
    t.float    "tempProb"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "location_id"
    t.integer  "minute"
    t.float    "windSpeedValue"
    t.float    "windSpeedProb"
    t.string   "windDirValue"
    t.float    "windDirProb"
  end

  add_index "predictions", ["location_id"], name: "index_predictions_on_location_id"

end
