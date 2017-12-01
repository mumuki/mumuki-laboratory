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

ActiveRecord::Schema.define(version: 20171201182621) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assignments", id: :serial, force: :cascade do |t|
    t.text "solution"
    t.integer "exercise_id"
    t.integer "status", default: 0
    t.text "result"
    t.integer "submitter_id"
    t.text "expectation_results"
    t.text "feedback"
    t.text "test_results"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "submissions_count", default: 0, null: false
    t.string "submission_id", limit: 255
    t.string "queries", limit: 255, default: [], array: true
    t.text "query_results"
    t.text "manual_evaluation_comment"
    t.index ["exercise_id"], name: "index_assignments_on_exercise_id"
    t.index ["submission_id"], name: "index_assignments_on_submission_id"
    t.index ["submitter_id"], name: "index_assignments_on_submitter_id"
  end

  create_table "books", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "locale", limit: 255, default: "en"
    t.string "contact_email", limit: 255, default: "info@mumuki.org", null: false
    t.text "description"
    t.string "slug", limit: 255
    t.index ["slug"], name: "index_books_on_slug", unique: true
  end

  create_table "chapters", id: :serial, force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "number", default: 0, null: false
    t.integer "book_id"
    t.integer "topic_id"
  end

  create_table "complements", id: :serial, force: :cascade do |t|
    t.integer "guide_id"
    t.integer "book_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["book_id"], name: "index_complements_on_book_id"
    t.index ["guide_id"], name: "index_complements_on_guide_id"
  end

  create_table "exam_authorizations", id: :serial, force: :cascade do |t|
    t.integer "exam_id"
    t.integer "user_id"
    t.boolean "started", default: false
    t.datetime "started_at"
    t.index ["exam_id"], name: "index_exam_authorizations_on_exam_id"
    t.index ["user_id"], name: "index_exam_authorizations_on_user_id"
  end

  create_table "exams", id: :serial, force: :cascade do |t|
    t.integer "organization_id"
    t.integer "guide_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "start_time", null: false
    t.datetime "end_time", null: false
    t.string "classroom_id", limit: 255
    t.integer "duration"
    t.index ["classroom_id"], name: "index_exams_on_classroom_id", unique: true
    t.index ["guide_id"], name: "index_exams_on_guide_id"
    t.index ["organization_id"], name: "index_exams_on_organization_id"
  end

  create_table "exercises", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.text "description"
    t.text "test"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "language_id", default: 0
    t.integer "submissions_count"
    t.integer "guide_id"
    t.string "locale", limit: 255, default: "en"
    t.text "hint"
    t.text "extra"
    t.integer "number"
    t.text "corollary"
    t.integer "layout", default: 0, null: false
    t.text "expectations"
    t.string "type", limit: 255, default: "Problem", null: false
    t.text "tag_list", default: [], array: true
    t.text "default_content"
    t.integer "bibliotheca_id", null: false
    t.boolean "extra_visible", default: false
    t.boolean "new_expectations", default: false
    t.boolean "manual_evaluation", default: false
    t.integer "editor", default: 0, null: false
    t.string "choices", limit: 255, default: [], null: false, array: true
    t.text "goal"
    t.index ["guide_id"], name: "index_exercises_on_guide_id"
    t.index ["language_id"], name: "index_exercises_on_language_id"
  end

  create_table "guides", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "description"
    t.string "locale", limit: 255, default: "en"
    t.integer "language_id"
    t.text "extra"
    t.text "corollary"
    t.boolean "beta", default: false
    t.text "expectations"
    t.string "slug", limit: 255, default: "", null: false
    t.integer "type", default: 0, null: false
    t.text "authors"
    t.text "contributors"
    t.index ["name"], name: "index_guides_on_name"
    t.index ["slug"], name: "index_guides_on_slug", unique: true
  end

  create_table "invitations", id: :serial, force: :cascade do |t|
    t.string "code", limit: 255
    t.string "course", limit: 255
    t.datetime "expiration_date"
    t.index ["code"], name: "index_invitations_on_code", unique: true
  end

  create_table "languages", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.string "runner_url", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "visible_success_output", default: false
    t.integer "output_content_type", default: 0
    t.string "highlight_mode", limit: 255
    t.text "description"
    t.boolean "queriable", default: false
    t.string "prompt", limit: 255
    t.boolean "stateful_console", default: false
    t.string "extension", limit: 255, default: "", null: false
    t.boolean "triable", default: false
    t.string "devicon", limit: 255
    t.string "comment_type", limit: 255, default: "cpp"
    t.index ["name"], name: "index_languages_on_name", unique: true
  end

  create_table "lessons", id: :serial, force: :cascade do |t|
    t.integer "guide_id"
    t.integer "number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "topic_id"
  end

  create_table "messages", id: :serial, force: :cascade do |t|
    t.string "submission_id", limit: 255
    t.text "content"
    t.string "sender", limit: 255
    t.datetime "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "read", default: false
  end

  create_table "organizations", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.integer "book_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "book_ids", default: [], array: true
    t.text "settings", default: "{}"
    t.text "theme", default: "{}"
    t.text "profile", default: "{}"
    t.index ["book_id"], name: "index_organizations_on_book_id"
  end

  create_table "paths", id: :serial, force: :cascade do |t|
    t.integer "category_id"
    t.integer "language_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["category_id"], name: "index_paths_on_category_id"
    t.index ["language_id"], name: "index_paths_on_language_id"
  end

  create_table "topics", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.string "locale", limit: 255
    t.text "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "appendix"
    t.string "slug", limit: 255
    t.index ["slug"], name: "index_topics_on_slug", unique: true
  end

  create_table "usages", id: :serial, force: :cascade do |t|
    t.integer "organization_id"
    t.string "slug", limit: 255
    t.integer "item_id"
    t.string "item_type", limit: 255
    t.integer "parent_item_id"
    t.string "parent_item_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["item_id", "item_type"], name: "index_usages_on_item_id_and_item_type"
    t.index ["organization_id"], name: "index_usages_on_organization_id"
    t.index ["parent_item_id", "parent_item_type"], name: "index_usages_on_parent_item_id_and_parent_item_type"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "provider", limit: 255
    t.string "social_id", limit: 255
    t.string "name", limit: 255
    t.string "token", limit: 255
    t.datetime "expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "email", limit: 255
    t.datetime "last_submission_date"
    t.string "image_url", limit: 255
    t.integer "last_exercise_id"
    t.string "remember_me_token", limit: 255
    t.integer "last_organization_id"
    t.string "uid", limit: 255, null: false
    t.text "permissions", default: "{}", null: false
    t.string "first_name", limit: 255
    t.string "last_name", limit: 255
    t.index ["last_organization_id"], name: "index_users_on_last_organization_id"
    t.index ["uid"], name: "index_users_on_uid", unique: true
  end

end
