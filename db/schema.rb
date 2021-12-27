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

ActiveRecord::Schema.define(version: 2021_10_17_213205) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "applications", force: :cascade do |t|
    t.text "name"
    t.text "redirect_uri"
    t.text "application_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "is_saml"
    t.text "saml_service_provider"
    t.text "saml_entity_id"
    t.text "saml_certificate"
    t.text "saml_private_key"
    t.text "saml_algorithm"
    t.uuid "owner"
  end

  create_table "logs", force: :cascade do |t|
    t.uuid "user"
    t.boolean "administrative"
    t.text "action"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "oauth_access_grants", force: :cascade do |t|
    t.integer "resource_owner", null: false
    t.integer "application", null: false
    t.string "token", null: false
    t.integer "expires_in", null: false
    t.text "redirect_uri", null: false
    t.datetime "created_at", null: false
    t.datetime "revoked_at"
    t.string "scopes"
    t.index ["token"], name: "index_oauth_access_grants_on_token", unique: true
  end

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer "resource_owner", null: false
    t.integer "application", null: false
    t.string "token", null: false
    t.string "refresh_token"
    t.integer "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at", null: false
    t.string "scopes"
    t.string "previous_refresh_token", default: "", null: false
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true
  end

  create_table "oauth_applications", force: :cascade do |t|
    t.string "name", null: false
    t.string "uid", null: false
    t.string "secret", null: false
    t.text "redirect_uri", null: false
    t.string "scopes", default: "", null: false
    t.boolean "confidential", default: true, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true
  end

  create_table "oauth_requests", force: :cascade do |t|
    t.string "client_id"
    t.string "redirect_uri"
    t.string "scope"
    t.string "response_mode"
    t.string "state"
    t.string "nonce"
    t.uuid "caller_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "saml_tokens", force: :cascade do |t|
    t.text "xml"
    t.uuid "uuid"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "relaystate"
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
    t.boolean "protected"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "tfa_enabled"
    t.text "reset_code"
  end

end
