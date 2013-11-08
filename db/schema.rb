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

ActiveRecord::Schema.define(version: 20131107220819) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "defects", force: true do |t|
    t.string   "defect_type",    null: false
    t.integer  "count",          null: false
    t.integer  "master_film_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "films", force: true do |t|
    t.integer  "division"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "master_film_id",                 null: false
    t.string   "phase",                          null: false
    t.text     "note"
    t.string   "shelf"
    t.decimal  "width"
    t.decimal  "length"
    t.boolean  "deleted",        default: false
    t.integer  "line_item_id"
  end

  create_table "line_items", force: true do |t|
    t.integer  "sales_order_id", null: false
    t.decimal  "custom_width"
    t.decimal  "custom_length"
    t.integer  "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "wire_length"
    t.string   "busbar_type"
    t.text     "note"
    t.string   "product_type"
  end

  create_table "machines", force: true do |t|
    t.string   "code",           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "yield_constant"
  end

  create_table "master_films", force: true do |t|
    t.string   "serial",           null: false
    t.string   "formula"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "mix_mass"
    t.string   "film_code"
    t.string   "thinky_code"
    t.integer  "machine_id"
    t.decimal  "effective_width"
    t.decimal  "effective_length"
    t.string   "operator"
    t.string   "chemist"
  end

  create_table "phase_snapshots", force: true do |t|
    t.string   "phase",      null: false
    t.integer  "count",      null: false
    t.decimal  "total_area", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sales_orders", force: true do |t|
    t.string   "code",         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "customer"
    t.date     "due_date"
    t.date     "release_date"
    t.string   "ship_to"
    t.date     "ship_date"
  end

  create_table "users", force: true do |t|
    t.string   "username"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "full_name"
    t.boolean  "chemist",         default: false
    t.boolean  "operator",        default: false
    t.string   "password_digest"
    t.integer  "role_level",      default: 0
  end

  create_table "versions", force: true do |t|
    t.string   "item_type",       null: false
    t.integer  "item_id",         null: false
    t.string   "event",           null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"
    t.string   "columns_changed",              array: true
    t.string   "phase_change",                 array: true
    t.decimal  "area"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

end
