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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130920162233) do

  create_table "defects", :force => true do |t|
    t.string   "defect_type"
    t.integer  "count"
    t.integer  "master_film_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "film_movements", :force => true do |t|
    t.string   "from"
    t.string   "to"
    t.decimal  "area"
    t.integer  "film_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "films", :force => true do |t|
    t.integer  "division"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.integer  "master_film_id"
    t.string   "phase"
    t.text     "reserved_for"
    t.text     "note"
    t.string   "shelf"
    t.decimal  "width"
    t.decimal  "length"
    t.string   "customer"
    t.string   "sales_order_code"
    t.decimal  "custom_width"
    t.decimal  "custom_length"
    t.boolean  "deleted",          :default => false
  end

  create_table "machines", :force => true do |t|
    t.string   "code"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.decimal  "yield_constant"
  end

  create_table "master_films", :force => true do |t|
    t.string   "serial"
    t.string   "formula"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.decimal  "mix_mass"
    t.string   "film_code"
    t.string   "thinky_code"
    t.integer  "operator_id"
    t.integer  "chemist_id"
    t.integer  "machine_id"
    t.decimal  "effective_width"
    t.decimal  "effective_length"
  end

  create_table "phase_snapshots", :force => true do |t|
    t.string   "phase"
    t.integer  "count"
    t.decimal  "total_area"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.string   "name"
    t.boolean  "chemist",    :default => false
    t.boolean  "operator",   :default => false
  end

end
