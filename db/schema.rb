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

ActiveRecord::Schema.define(version: 2018_04_22_042206) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "infected_reports", force: :cascade do |t|
    t.bigint "survivor_id"
    t.integer "reporter_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["survivor_id"], name: "index_infected_reports_on_survivor_id"
  end

  create_table "inventories", force: :cascade do |t|
    t.bigint "survivor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["survivor_id"], name: "index_inventories_on_survivor_id"
  end

  create_table "inventory_resources", force: :cascade do |t|
    t.bigint "inventory_id"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["inventory_id"], name: "index_inventory_resources_on_inventory_id"
    t.index ["resource_id"], name: "index_inventory_resources_on_resource_id"
  end

  create_table "resources", force: :cascade do |t|
    t.string "item"
    t.integer "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "survivors", force: :cascade do |t|
    t.string "name"
    t.integer "age"
    t.string "gender"
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
    t.boolean "infected"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "infected_reports", "survivors"
  add_foreign_key "inventories", "survivors"
  add_foreign_key "inventory_resources", "inventories"
  add_foreign_key "inventory_resources", "resources"
end
