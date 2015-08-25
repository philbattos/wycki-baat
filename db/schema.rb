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

ActiveRecord::Schema.define(version: 20150819064232) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "baats", force: :cascade do |t|
    t.string   "name"
    t.string   "destination"
    t.string   "type"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.text     "files",       default: [],              array: true
  end

  create_table "folios", force: :cascade do |t|
    t.string   "name"
    t.string   "destination"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "images", force: :cascade do |t|
    t.string   "name"
    t.string   "destination"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "templates", force: :cascade do |t|
    t.string   "name"
    t.string   "destination"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.text     "files",       default: [],              array: true
  end

  create_table "texts", force: :cascade do |t|
    t.string   "name"
    t.string   "destination"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "volumes", force: :cascade do |t|
    t.string   "name"
    t.string   "destination"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "wiki_bots", force: :cascade do |t|
    t.string   "name"
    t.string   "site_url"
    t.string   "api_endpoint"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

end
