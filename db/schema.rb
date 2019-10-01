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

ActiveRecord::Schema.define(version: 2019_10_01_054436) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "areas", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "areas_users", id: false, force: :cascade do |t|
    t.integer "area_id"
    t.integer "user_id"
  end

  create_table "brochures", force: :cascade do |t|
    t.binary "content"
    t.binary "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.integer "rotation"
  end

  create_table "broshejointables", force: :cascade do |t|
    t.integer "sheet_id"
    t.integer "brochure_id"
    t.integer "order_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "capacitycodes", force: :cascade do |t|
    t.string "text"
    t.integer "capacity_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "capacitylogs", force: :cascade do |t|
    t.integer "user_id"
    t.string "comment"
    t.integer "capacity_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "absent"
    t.datetime "return_date"
  end

  create_table "conshejointables", force: :cascade do |t|
    t.integer "contact_id", default: 0
    t.integer "sheet_id", default: 0
    t.integer "order_number", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "description_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.string "first_name", default: ""
    t.string "last_name", default: ""
    t.string "position", default: ""
    t.string "email_address", default: ""
    t.string "tel_number", default: ""
    t.string "mobile_number", default: ""
    t.string "url", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "rotation", default: 0
    t.binary "image"
  end

  create_table "contacts_sheets", force: :cascade do |t|
    t.integer "sheet_id", default: 0
    t.integer "contact_id", default: 0
    t.integer "order_number", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "description_id"
  end

  create_table "descriptions", force: :cascade do |t|
    t.text "text"
    t.integer "contact_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "loginlogs", force: :cascade do |t|
    t.integer "user_id"
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sheets", force: :cascade do |t|
    t.string "client_name", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "number", default: "000000"
    t.string "password"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "user_type"
    t.string "location"
    t.string "position"
    t.integer "capacity_status"
    t.string "department"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "telephone"
    t.string "email"
    t.string "password"
  end

end
