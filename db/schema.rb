# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_01_18_170220) do
  create_table "ahoy_events", force: :cascade do |t|
    t.integer "visit_id"
    t.integer "user_id"
    t.string "name"
    t.text "properties"
    t.datetime "time"
    t.index ["name", "time"], name: "index_ahoy_events_on_name_and_time"
    t.index ["user_id"], name: "index_ahoy_events_on_user_id"
    t.index ["visit_id"], name: "index_ahoy_events_on_visit_id"
  end

  create_table "ahoy_visits", force: :cascade do |t|
    t.string "visit_token"
    t.string "visitor_token"
    t.integer "user_id"
    t.string "ip"
    t.text "user_agent"
    t.text "referrer"
    t.string "referring_domain"
    t.text "landing_page"
    t.string "browser"
    t.string "os"
    t.string "device_type"
    t.string "country"
    t.string "region"
    t.string "city"
    t.float "latitude"
    t.float "longitude"
    t.string "utm_source"
    t.string "utm_medium"
    t.string "utm_term"
    t.string "utm_content"
    t.string "utm_campaign"
    t.string "app_version"
    t.string "os_version"
    t.string "platform"
    t.datetime "started_at"
    t.index ["user_id"], name: "index_ahoy_visits_on_user_id"
    t.index ["visit_token"], name: "index_ahoy_visits_on_visit_token", unique: true
    t.index ["visitor_token", "started_at"], name: "index_ahoy_visits_on_visitor_token_and_started_at"
  end

  create_table "blogs", force: :cascade do |t|
    t.string "blog_type"
    t.string "title"
    t.string "summary"
    t.string "body"
    t.string "image"
    t.string "slug"
    t.json "data", default: {}
    t.datetime "published_at"
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_blogs_on_discarded_at"
    t.index ["slug"], name: "index_blogs_on_slug"
  end

  create_table "questions", force: :cascade do |t|
    t.integer "topic_id"
    t.string "title"
    t.json "answers"
    t.string "answer"
    t.integer "status"
    t.string "key"
    t.string "nanoid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "data", default: {}
    t.index ["topic_id", "title"], name: "index_questions_on_topic_id_and_title", unique: true
    t.index ["topic_id"], name: "index_questions_on_topic_id"
  end

  create_table "quiz_questions", force: :cascade do |t|
    t.integer "quiz_id"
    t.integer "question_id"
    t.integer "attempts"
    t.integer "skipped"
    t.integer "answered"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "ordinal"
    t.index ["question_id"], name: "index_quiz_questions_on_question_id"
    t.index ["quiz_id", "question_id"], name: "index_quiz_questions_on_quiz_id_and_question_id", unique: true
    t.index ["quiz_id"], name: "index_quiz_questions_on_quiz_id"
  end

  create_table "quizzes", force: :cascade do |t|
    t.integer "user_id"
    t.integer "topic_id"
    t.string "title"
    t.json "questions"
    t.integer "status"
    t.json "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "started_at"
    t.datetime "finished_at"
    t.index ["topic_id"], name: "index_quizzes_on_topic_id"
    t.index ["user_id"], name: "index_quizzes_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "super_topics", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.string "country_code"
    t.string "key"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "summary"
    t.index ["title", "country_code"], name: "index_super_topics_on_title_and_country_code", unique: true
  end

  create_table "topics", force: :cascade do |t|
    t.integer "super_topic_id"
    t.integer "topics_id"
    t.integer "parent_topic_id"
    t.string "title"
    t.string "description"
    t.integer "status"
    t.string "key"
    t.string "summary"
    t.string "help_text"
    t.index ["parent_topic_id"], name: "index_topics_on_parent_topic_id"
    t.index ["super_topic_id", "title"], name: "index_topics_on_super_topic_id_and_title", unique: true
    t.index ["super_topic_id"], name: "index_topics_on_super_topic_id"
    t.index ["topics_id"], name: "index_topics_on_topics_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.string "nanoid"
    t.string "original_session_nanoid"
    t.json "data", default: {}
    t.integer "status"
    t.string "name"
    t.string "avatar"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "sessions", "users"
end
