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

ActiveRecord::Schema.define(version: 20141204144920) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "super_admin"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "buildings", force: :cascade do |t|
    t.string   "name"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "buildings", ["project_id"], name: "index_buildings_on_project_id", using: :btree

  create_table "customers", force: :cascade do |t|
    t.string   "name"
    t.string   "address"
    t.string   "phone"
    t.string   "email"
    t.integer  "admin_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "customers", ["admin_user_id"], name: "index_customers_on_admin_user_id", using: :btree

  create_table "floors", force: :cascade do |t|
    t.string   "name"
    t.integer  "building_id"
    t.string   "plan_file_name"
    t.string   "plan_content_type"
    t.integer  "plan_file_size"
    t.datetime "plan_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "floors", ["building_id"], name: "index_floors_on_building_id", using: :btree

  create_table "logs", force: :cascade do |t|
    t.integer  "tag_id"
    t.float    "temp"
    t.float    "humidity"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "datetime",   limit: 8
    t.integer  "reading_id"
    t.float    "pressure"
  end

  add_index "logs", ["reading_id"], name: "index_logs_on_reading_id", using: :btree
  add_index "logs", ["tag_id"], name: "index_logs_on_tag_id", using: :btree

  create_table "projects", force: :cascade do |t|
    t.string   "name"
    t.integer  "customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tag_id"
  end

  add_index "projects", ["customer_id"], name: "index_projects_on_customer_id", using: :btree
  add_index "projects", ["tag_id"], name: "index_projects_on_tag_id", using: :btree

  create_table "readings", force: :cascade do |t|
    t.text     "data"
    t.integer  "tag_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "offset"
    t.integer  "log_interval"
    t.integer  "time",         limit: 8
  end

  add_index "readings", ["tag_id"], name: "index_readings_on_tag_id", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.string   "uid"
    t.string   "epc"
    t.string   "code"
    t.float    "x"
    t.float    "y"
    t.integer  "floor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "active"
    t.string   "status"
    t.integer  "interval"
  end

  add_index "tags", ["floor_id"], name: "index_tags_on_floor_id", using: :btree

end
