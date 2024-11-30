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

ActiveRecord::Schema[7.1].define(version: 2024_11_30_201813) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "plpgsql"

  create_table "job_types", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.text "training_module"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "jobs", force: :cascade do |t|
    t.date "shift_date"
    t.bigint "opener_id", null: false
    t.bigint "cover_id", null: false
    t.string "location_name"
    t.datetime "shift_started_at"
    t.datetime "shift_ended_at"
    t.string "location_address"
    t.string "title"
    t.text "description"
    t.bigint "job_type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cover_id"], name: "index_jobs_on_cover_id"
    t.index ["job_type_id"], name: "index_jobs_on_job_type_id"
    t.index ["opener_id"], name: "index_jobs_on_opener_id"
  end

  create_table "users", force: :cascade do |t|
    t.citext "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.citext "name"
    t.string "password"
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["name"], name: "index_users_on_name", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "jobs", "job_types"
  add_foreign_key "jobs", "users", column: "cover_id"
  add_foreign_key "jobs", "users", column: "opener_id"
end
