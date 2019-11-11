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

ActiveRecord::Schema.define(version: 2019_11_10_164601) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "areas", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "group_id"
  end

  create_table "areas_users", id: false, force: :cascade do |t|
    t.integer "area_id"
    t.integer "user_id"
  end

  create_table "capacitycodes", force: :cascade do |t|
    t.string "text"
    t.integer "capacity_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "alert"
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

  create_table "departments", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "group_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "groupuserlookups", force: :cascade do |t|
    t.integer "user_id"
    t.integer "group_id"
    t.boolean "selected"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "locations", force: :cascade do |t|
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

  create_table "objectives", force: :cascade do |t|
    t.text "text"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "user_type"
    t.string "position"
    t.integer "capacity_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "telephone"
    t.string "email"
    t.string "password"
    t.integer "location_id"
    t.integer "department_id"
    t.date "history_start_date"
    t.date "history_end_date"
    t.boolean "is_manager"
    t.date "leaving_date"
  end

end
