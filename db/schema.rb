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

ActiveRecord::Schema.define(version: 20211128033830) do

  create_table "chefs", force: :cascade do |t|
    t.string   "chefname"
    t.string   "email"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "password_digest"
    t.boolean  "admin",           default: false
  end

  create_table "comments", force: :cascade do |t|
    t.text     "description"
    t.integer  "chef_id"
    t.integer  "recipe_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "cronreport_distributions", force: :cascade do |t|
    t.integer "cronreport_id"
    t.integer "user_id"
  end

  create_table "cronreports", force: :cascade do |t|
    t.integer "lookup_id"
    t.text    "name"
  end

  create_table "ingredients", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lookups", force: :cascade do |t|
    t.text "lookup_type"
    t.text "short_name"
  end

  create_table "messages", force: :cascade do |t|
    t.text     "content"
    t.integer  "chef_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "recipe_ingredients", force: :cascade do |t|
    t.integer "recipe_id"
    t.integer "ingredient_id"
  end

  create_table "recipes", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "chef_id",     limit: 8
  end

  create_table "users", force: :cascade do |t|
    t.text "email"
  end

end
