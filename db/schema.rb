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

ActiveRecord::Schema.define(version: 20160414150800) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: true do |t|
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

  create_table "admin_users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "api_tokens", force: true do |t|
    t.string   "client_secret"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "client_id",     null: false
  end

  create_table "assignments", force: true do |t|
    t.text     "solution"
    t.integer  "exercise_id"
    t.integer  "status",              default: 0
    t.text     "result"
    t.integer  "submitter_id"
    t.text     "expectation_results"
    t.text     "feedback"
    t.text     "test_results"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "submissions_count",   default: 0, null: false
    t.string   "submission_id"
  end

  add_index "assignments", ["exercise_id"], name: "index_assignments_on_exercise_id", using: :btree
  add_index "assignments", ["submitter_id"], name: "index_assignments_on_submitter_id", using: :btree

  create_table "books", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "locale",        default: "en"
    t.string   "contact_email", default: "info@mumuki.org", null: false
    t.text     "preface"
  end

  create_table "chapters", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "locale"
    t.string   "image_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "number",           default: 0, null: false
    t.text     "links"
    t.text     "long_description"
  end

  create_table "comments", force: true do |t|
    t.integer  "exercise_id"
    t.string   "submission_id"
    t.string   "type"
    t.text     "content"
    t.string   "author"
    t.datetime "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "read",          default: false
  end

  create_table "event_subscribers", force: true do |t|
    t.string   "url"
    t.boolean  "enabled"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "exercises", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.text     "test"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "language_id",       default: 0
    t.integer  "submissions_count"
    t.integer  "guide_id"
    t.string   "locale",            default: "en"
    t.text     "hint"
    t.text     "extra"
    t.integer  "number"
    t.text     "corollary"
    t.integer  "layout",            default: 0,         null: false
    t.text     "expectations"
    t.string   "slug"
    t.string   "type",              default: "Problem", null: false
    t.text     "tag_list",          default: [],                     array: true
    t.string   "default_content"
    t.integer  "bibliotheca_id",                        null: false
    t.boolean  "extra_visible",     default: false
  end

  add_index "exercises", ["guide_id"], name: "index_exercises_on_guide_id", using: :btree
  add_index "exercises", ["language_id"], name: "index_exercises_on_language_id", using: :btree
  add_index "exercises", ["slug"], name: "index_exercises_on_slug", unique: true, using: :btree

  create_table "guides", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.string   "locale",       default: "en"
    t.integer  "language_id"
    t.text     "extra"
    t.text     "corollary"
    t.boolean  "beta",         default: false
    t.text     "expectations"
    t.string   "slug",         default: "",    null: false
    t.integer  "type",         default: 0,     null: false
  end

  add_index "guides", ["name"], name: "index_guides_on_name", using: :btree

  create_table "languages", force: true do |t|
    t.string   "name"
    t.string   "test_runner_url"
    t.string   "devicon"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "visible_success_output", default: false
    t.integer  "output_content_type",    default: 0
    t.string   "highlight_mode"
    t.text     "description"
    t.boolean  "queriable",              default: false
  end

  add_index "languages", ["name"], name: "index_languages_on_name", unique: true, using: :btree

  create_table "lessons", force: true do |t|
    t.integer  "guide_id"
    t.integer  "chapter_id"
    t.integer  "number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  create_table "paths", force: true do |t|
    t.integer  "category_id"
    t.integer  "language_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "paths", ["category_id"], name: "index_paths_on_category_id", using: :btree
  add_index "paths", ["language_id"], name: "index_paths_on_language_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "token"
    t.datetime "expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
    t.datetime "last_submission_date"
    t.string   "image_url"
    t.integer  "last_exercise_id"
    t.string   "remember_me_token"
  end

end
