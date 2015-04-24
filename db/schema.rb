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

ActiveRecord::Schema.define(version: 20150424180136) do

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

  create_table "collaborators", force: true do |t|
    t.integer "guide_id"
    t.integer "user_id"
  end

  add_index "collaborators", ["guide_id", "user_id"], name: "index_collaborators_on_guide_id_and_user_id", unique: true, using: :btree

  create_table "contributors", force: true do |t|
    t.integer "guide_id"
    t.integer "user_id"
  end

  add_index "contributors", ["guide_id", "user_id"], name: "index_contributors_on_guide_id_and_user_id", unique: true, using: :btree

  create_table "exercises", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.text     "test"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "language_id",       default: 0
    t.integer  "submissions_count"
    t.integer  "author_id"
    t.integer  "guide_id"
    t.integer  "original_id"
    t.string   "locale",            default: "en"
    t.text     "hint"
    t.text     "extra_code"
    t.integer  "position"
  end

  add_index "exercises", ["author_id"], name: "index_exercises_on_author_id", using: :btree
  add_index "exercises", ["guide_id"], name: "index_exercises_on_guide_id", using: :btree
  add_index "exercises", ["language_id"], name: "index_exercises_on_language_id", using: :btree

  create_table "expectations", force: true do |t|
    t.integer  "exercise_id"
    t.string   "binding"
    t.string   "inspection"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "exports", force: true do |t|
    t.integer  "guide_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status",       default: 0
    t.text     "result"
    t.integer  "committer_id"
  end

  add_index "exports", ["guide_id"], name: "index_exports_on_guide_id", using: :btree

  create_table "guides", force: true do |t|
    t.string   "github_repository"
    t.string   "name"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.string   "original_id_format", default: "%05d", null: false
    t.string   "locale"
    t.integer  "language_id"
  end

  add_index "guides", ["author_id"], name: "index_guides_on_author_id", using: :btree
  add_index "guides", ["name"], name: "index_guides_on_name", unique: true, using: :btree

  create_table "imports", force: true do |t|
    t.integer  "guide_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status",       default: 0
    t.text     "result"
    t.integer  "committer_id"
  end

  create_table "languages", force: true do |t|
    t.string   "name"
    t.string   "test_runner_url"
    t.string   "extension"
    t.string   "image_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "languages", ["extension"], name: "index_languages_on_extension", unique: true, using: :btree
  add_index "languages", ["name"], name: "index_languages_on_name", unique: true, using: :btree

  create_table "relationships", force: true do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "submissions", force: true do |t|
    t.text     "content"
    t.integer  "exercise_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status",              default: 0
    t.text     "result"
    t.integer  "submitter_id"
    t.text     "expectation_results"
  end

  add_index "submissions", ["submitter_id"], name: "index_submissions_on_submitter_id", using: :btree

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: true do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

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
  end

  add_index "users", ["name"], name: "index_users_on_name", unique: true, using: :btree

end
