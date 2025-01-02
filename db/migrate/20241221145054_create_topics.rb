class CreateTopics < ActiveRecord::Migration[8.0]
  def change
    create_table "questions" do |t|
      t.integer "topic_id"
      t.string "title"
      t.json "answers"
      t.string "answer"
      t.integer "status"
      t.string "key"
      t.jsonb "data", default: {}
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["topic_id", "title"], name: "index_questions_on_topic_id_and_title", unique: true
      t.index ["topic_id"], name: "index_questions_on_topic_id"
    end

    create_table "quiz_questions" do |t|
      t.integer "quiz_id"
      t.integer "question_id"
      t.integer "attempts"
      t.integer "skipped"
      t.integer "answered"
      t.jsonb "attempted_answers", default: []
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.integer "ordinal"
      t.index ["question_id"], name: "index_quiz_questions_on_question_id"
      t.index ["quiz_id", "question_id"], name: "index_quiz_questions_on_quiz_id_and_question_id", unique: true
      t.index ["quiz_id"], name: "index_quiz_questions_on_quiz_id"
    end

    create_table "quizzes" do |t|
      t.integer "user_id"
      t.integer "topic_id"
      t.string "title"
      t.json "questions"
      t.integer "status"
      t.json "data"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["topic_id"], name: "index_quizzes_on_topic_id"
      t.index ["user_id"], name: "index_quizzes_on_user_id"
    end

    create_table "super_topics" do |t|
      t.string "title"
      t.string "description"
      t.string "country_code"
      t.string "key"
      t.integer "status"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["title", "country_code"], name: "index_super_topics_on_title_and_country_code", unique: true
    end

    create_table "topics" do |t|
      t.integer "super_topic_id"
      t.integer "topics_id"
      t.integer "parent_topic_id"
      t.string "title"
      t.string "description"
      t.integer "status"
      t.string "key"
      t.index ["parent_topic_id"], name: "index_topics_on_parent_topic_id"
      t.index ["super_topic_id", "title"], name: "index_topics_on_super_topic_id_and_title", unique: true
      t.index ["super_topic_id"], name: "index_topics_on_super_topic_id"
      t.index ["topics_id"], name: "index_topics_on_topics_id"
    end

    create_table "users" do |t|
      t.integer "status"
      t.string "email"
      t.string "name"
      t.string "avatar"
      t.json "data"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
  end
end
