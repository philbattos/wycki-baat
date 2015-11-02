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

ActiveRecord::Schema.define(version: 20151101070506) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "baats", force: :cascade do |t|
    t.string   "name"
    t.string   "destination"
    t.string   "type"
    t.string   "collection"
    t.text     "files",       default: [],              array: true
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "collections", force: :cascade do |t|
    t.string   "name"
    t.string   "destination"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "contents", force: :cascade do |t|
    t.string   "name"
    t.string   "destination"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "images", force: :cascade do |t|
    t.string   "name"
    t.string   "destination"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "aasm_state"
    t.text     "api_response"
    t.string   "image_file"
    t.string   "image_url"
    t.string   "collection_name"
    t.integer  "collection_id"
  end

  create_table "pdf_originals", force: :cascade do |t|
    t.string   "name"
    t.string   "destination"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "aasm_state"
    t.text     "api_response"
    t.string   "pdf_file"
    t.string   "pdf_url"
    t.string   "collection_name"
    t.integer  "collection_id"
  end

  create_table "templates", force: :cascade do |t|
    t.string   "name"
    t.text     "content"
    t.string   "destination"
    t.string   "type"
    t.text     "file_path"
    t.text     "file_name"
    t.text     "file_headers"
    t.string   "file_root"
    t.string   "file_extension"
    t.text     "categories",      default: [],              array: true
    t.decimal  "file_size"
    t.text     "api_response"
    t.string   "aasm_state"
    t.integer  "collection_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "collection_name"
  end

  create_table "texts", force: :cascade do |t|
    t.text     "name"
    t.text     "content"
    t.string   "destination"
    t.string   "type"
    t.text     "file_path"
    t.text     "file_name"
    t.text     "file_headers"
    t.string   "file_root"
    t.string   "file_extension"
    t.text     "categories",     default: [],              array: true
    t.integer  "volume_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.decimal  "file_size"
    t.text     "api_response"
    t.string   "aasm_state"
  end

  create_table "volumes", force: :cascade do |t|
    t.string   "name"
    t.text     "content"
    t.string   "destination"
    t.string   "type"
    t.integer  "collection_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "aasm_state"
    t.text     "api_response"
    t.string   "collection_name"
  end

end
