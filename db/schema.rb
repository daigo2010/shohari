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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120207143910) do

  create_table "answers", :force => true do |t|
    t.integer  "answer_user_id"
    t.integer  "target_user_id"
    t.integer  "question_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "answers", ["answer_user_id"], :name => "index_answers_on_answer_user_id"
  add_index "answers", ["target_user_id"], :name => "index_answers_on_target_user_id"

  create_table "questions", :force => true do |t|
    t.string   "question"
    t.string   "location"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "questions", ["location"], :name => "index_questions_on_location"

  create_table "users", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "screen_name"
    t.string   "email"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "users", ["provider", "uid"], :name => "index_users_on_provider_and_uid"

end
