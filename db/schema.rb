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

ActiveRecord::Schema.define(version: 20141223062841) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "dimensions", force: true do |t|
    t.decimal "width",   default: 0.0, null: false
    t.decimal "length",  default: 0.0, null: false
    t.integer "film_id",               null: false
  end

  add_index "dimensions", ["film_id"], name: "index_dimensions_on_film_id", using: :btree

  create_table "film_movements", force: true do |t|
    t.string   "from_phase",                null: false
    t.string   "to_phase",                  null: false
    t.decimal  "width",       default: 0.0, null: false
    t.decimal  "length",      default: 0.0, null: false
    t.string   "actor",                     null: false
    t.integer  "film_id",                   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "tenant_code",               null: false
  end

  add_index "film_movements", ["created_at"], name: "index_film_movements_on_created_at", using: :btree
  add_index "film_movements", ["film_id"], name: "index_film_movements_on_film_id", using: :btree
  add_index "film_movements", ["tenant_code"], name: "index_film_movements_on_tenant_code", using: :btree

  create_table "films", force: true do |t|
    t.integer "master_film_id",                   null: false
    t.text    "note"
    t.string  "shelf"
    t.boolean "deleted",          default: false
    t.integer "sales_order_id"
    t.integer "order_fill_count", default: 1,     null: false
    t.string  "tenant_code",                      null: false
    t.string  "serial",                           null: false
    t.decimal "area",             default: 0.0,   null: false
    t.integer "phase",            default: 0,     null: false
  end

  add_index "films", ["area"], name: "index_films_on_area", using: :btree
  add_index "films", ["deleted"], name: "index_films_on_deleted", using: :btree
  add_index "films", ["master_film_id"], name: "index_films_on_master_film_id", using: :btree
  add_index "films", ["sales_order_id"], name: "index_films_on_sales_order_id", using: :btree
  add_index "films", ["serial"], name: "index_films_on_serial", using: :btree
  add_index "films", ["tenant_code"], name: "index_films_on_tenant_code", using: :btree

  create_table "line_items", force: true do |t|
    t.integer "sales_order_id", null: false
    t.decimal "custom_width",   null: false
    t.decimal "custom_length",  null: false
    t.integer "quantity",       null: false
    t.string  "wire_length"
    t.string  "busbar_type"
    t.text    "note"
    t.string  "product_type",   null: false
  end

  add_index "line_items", ["sales_order_id"], name: "index_line_items_on_sales_order_id", using: :btree

  create_table "machines", force: true do |t|
    t.string  "code",           null: false
    t.decimal "yield_constant", null: false
    t.string  "tenant_code",    null: false
  end

  add_index "machines", ["tenant_code"], name: "index_machines_on_tenant_code", using: :btree

  create_table "master_films", force: true do |t|
    t.string   "serial",                                  null: false
    t.string   "formula"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "mix_mass"
    t.string   "film_code"
    t.string   "thinky_code"
    t.integer  "machine_id"
    t.decimal  "effective_width",  default: 0.0,          null: false
    t.decimal  "effective_length", default: 0.0,          null: false
    t.string   "operator"
    t.string   "chemist"
    t.text     "note"
    t.hstore   "defects",          default: {},           null: false
    t.string   "tenant_code",                             null: false
    t.decimal  "micrometer_left"
    t.decimal  "micrometer_right"
    t.decimal  "run_speed"
    t.string   "inspector"
    t.date     "serial_date",      default: '2014-05-15', null: false
    t.integer  "function",         default: 0,            null: false
    t.decimal  "yield"
    t.decimal  "temperature"
    t.decimal  "humidity"
  end

  add_index "master_films", ["defects"], name: "master_films_defects", using: :gin
  add_index "master_films", ["machine_id"], name: "index_master_films_on_machine_id", using: :btree
  add_index "master_films", ["serial"], name: "index_master_films_on_serial", using: :btree
  add_index "master_films", ["tenant_code"], name: "index_master_films_on_tenant_code", using: :btree

  create_table "sales_orders", force: true do |t|
    t.string   "code",                     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "customer"
    t.date     "due_date",                 null: false
    t.date     "release_date",             null: false
    t.string   "ship_to"
    t.date     "ship_date"
    t.text     "note"
    t.string   "tenant_code",              null: false
    t.integer  "status",       default: 0, null: false
  end

  add_index "sales_orders", ["due_date"], name: "index_sales_orders_on_due_date", using: :btree
  add_index "sales_orders", ["ship_date"], name: "index_sales_orders_on_ship_date", using: :btree
  add_index "sales_orders", ["tenant_code"], name: "index_sales_orders_on_tenant_code", using: :btree

  create_table "users", force: true do |t|
    t.string   "username",                        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "full_name",                       null: false
    t.boolean  "chemist",         default: false
    t.boolean  "operator",        default: false
    t.string   "password_digest",                 null: false
    t.integer  "role_level",      default: 0,     null: false
    t.string   "tenant_code",                     null: false
    t.boolean  "inspector",       default: false, null: false
  end

  add_index "users", ["tenant_code"], name: "index_users_on_tenant_code", using: :btree

end
