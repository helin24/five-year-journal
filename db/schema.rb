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

ActiveRecord::Schema.define(version: 20160718005252) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authentications", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "login_id"
    t.string   "login_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "authentications", ["login_type", "login_id"], name: "index_authentications_on_login_type_and_login_id", using: :btree

  create_table "entries", force: :cascade do |t|
    t.integer  "user_id"
    t.date     "display_date"
    t.text     "text"
    t.boolean  "is_public"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "entries", ["user_id", "display_date"], name: "index_entries_on_user_id_and_display_date", unique: true, using: :btree

  create_table "google_authentications", force: :cascade do |t|
    t.string   "email"
    t.string   "name"
    t.string   "profile_url"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "google_authentications", ["email"], name: "index_google_authentications_on_email", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
