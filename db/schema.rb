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

ActiveRecord::Schema.define(version: 20160729194600) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.text     "description"
    t.string   "slug"
  end

  add_index "books", ["slug"], name: "index_books_on_slug", unique: true, using: :btree

  create_table "chapters", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "number",     default: 0, null: false
    t.integer  "book_id"
    t.integer  "topic_id"
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

  create_table "complements", force: true do |t|
    t.integer  "guide_id"
    t.integer  "book_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "complements", ["book_id"], name: "index_complements_on_book_id", using: :btree
  add_index "complements", ["guide_id"], name: "index_complements_on_guide_id", using: :btree

  create_table "exam_authorizations", force: true do |t|
    t.integer  "exam_id"
    t.integer  "user_id"
    t.boolean  "started",    default: false
    t.datetime "started_at"
  end

  add_index "exam_authorizations", ["exam_id"], name: "index_exam_authorizations_on_exam_id", using: :btree
  add_index "exam_authorizations", ["user_id"], name: "index_exam_authorizations_on_user_id", using: :btree

  create_table "exams", force: true do |t|
    t.integer  "organization_id"
    t.integer  "guide_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "start_time",      null: false
    t.datetime "end_time",        null: false
    t.string   "classroom_id"
    t.integer  "duration"
  end

  add_index "exams", ["classroom_id"], name: "index_exams_on_classroom_id", unique: true, using: :btree
  add_index "exams", ["guide_id"], name: "index_exams_on_guide_id", using: :btree
  add_index "exams", ["organization_id"], name: "index_exams_on_organization_id", using: :btree

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
    t.text     "default_content"
    t.integer  "bibliotheca_id",                        null: false
    t.boolean  "extra_visible",     default: false
    t.boolean  "new_expectations",  default: false
    t.boolean  "manual_evaluation", default: false
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
    t.string   "runner_url"
    t.string   "devicon"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "visible_success_output", default: false
    t.integer  "output_content_type",    default: 0
    t.string   "highlight_mode"
    t.text     "description"
    t.boolean  "queriable",              default: false
    t.string   "prompt"
    t.boolean  "stateful_console",       default: false
  end

  add_index "languages", ["name"], name: "index_languages_on_name", unique: true, using: :btree

  create_table "lessons", force: true do |t|
    t.integer  "guide_id"
    t.integer  "number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "topic_id"
  end

  create_table "organizations", force: true do |t|
    t.string   "name"
    t.string   "contact_email"
    t.text     "description"
    t.integer  "book_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "private",       default: false
    t.string   "logo_url"
    t.string   "login_methods", default: ["facebook", "github", "google", "twitter", "user_pass"], null: false, array: true
  end

  add_index "organizations", ["book_id"], name: "index_organizations_on_book_id", using: :btree

  create_table "paths", force: true do |t|
    t.integer  "category_id"
    t.integer  "language_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "paths", ["category_id"], name: "index_paths_on_category_id", using: :btree
  add_index "paths", ["language_id"], name: "index_paths_on_language_id", using: :btree

  create_table "topics", force: true do |t|
    t.string   "name"
    t.string   "locale"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "long_description"
    t.string   "slug"
  end

  add_index "topics", ["slug"], name: "index_topics_on_slug", unique: true, using: :btree

  create_table "usages", force: true do |t|
    t.integer  "organization_id"
    t.string   "slug"
    t.integer  "item_id"
    t.string   "item_type"
    t.integer  "parent_item_id"
    t.string   "parent_item_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "usages", ["item_id", "item_type"], name: "index_usages_on_item_id_and_item_type", using: :btree
  add_index "usages", ["organization_id"], name: "index_usages_on_organization_id", using: :btree
  add_index "usages", ["parent_item_id", "parent_item_type"], name: "index_usages_on_parent_item_id_and_parent_item_type", using: :btree

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
    t.text     "metadata",             default: "{}", null: false
    t.integer  "last_organization_id"
  end

  add_index "users", ["last_organization_id"], name: "index_users_on_last_organization_id", using: :btree

end
