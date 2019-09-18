# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_09_18_040415) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "logs", force: :cascade do |t|
    t.uuid "user"
    t.boolean "administrative"
    t.text "action"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "settings", force: :cascade do |t|
    t.string "site_name"
    t.string "site_protocol"
    t.string "recaptcha_site_key"
    t.string "recaptcha_secret_key"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.date "date_of_birth"
    t.integer "permission_level"
    t.string "password_digest"
    t.string "password_hash"
    t.string "encryption_key"
    t.inet "last_login_ip"
    t.string "fingerprints"
    t.string "tfa_key"
    t.uuid "user_global_id"
    t.string "api_key"
    t.string "activation_token"
    t.boolean "activated"
    t.boolean "active"
    t.boolean "shell_active"
    t.boolean "protected"
    t.string "shell_username"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "tfa_enabled"
  end

end
