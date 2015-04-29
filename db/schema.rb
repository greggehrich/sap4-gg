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

ActiveRecord::Schema.define(version: 20150428204606) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "author_story_assignments", force: :cascade do |t|
    t.integer  "authors_id", null: false
    t.integer  "stories_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "author_story_assignments", ["authors_id", "stories_id"], name: "index_author_story_assignments_on_authors_id_and_stories_id", unique: true, using: :btree

  create_table "authors", force: :cascade do |t|
    t.string   "email"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fips", force: :cascade do |t|
    t.integer  "fips",         null: false
    t.string   "msa_infos_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "fips", ["fips"], name: "index_fips_on_fips", using: :btree
  add_index "fips", ["msa_infos_id"], name: "index_fips_on_msa_infos_id", using: :btree

  create_table "images", force: :cascade do |t|
    t.string "image_type",                       null: false
    t.string "image_size_h"
    t.string "image_size_v"
    t.string "source",       default: "scraped"
  end

  add_index "images", ["image_type"], name: "index_images_on_image_type", using: :btree

  create_table "locations", force: :cascade do |t|
    t.string   "lat",          null: false
    t.string   "lng",          null: false
    t.string   "name",         null: false
    t.integer  "parent_id"
    t.integer  "zip_codes_id"
    t.integer  "msa_infos_id"
    t.integer  "fips_id"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "locations", ["lat"], name: "index_locations_on_lat", using: :btree
  add_index "locations", ["lng"], name: "index_locations_on_lng", using: :btree
  add_index "locations", ["name"], name: "index_locations_on_name", using: :btree
  add_index "locations", ["parent_id"], name: "index_locations_on_parent_id", using: :btree
  add_index "locations", ["zip_codes_id"], name: "index_locations_on_zip_codes_id", using: :btree

  create_table "media_types", force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "medias", force: :cascade do |t|
    t.string  "title",                   null: false
    t.integer "parent_id"
    t.string  "name"
    t.string  "media_type_id"
    t.string  "distribution_type"
    t.string  "publication_name"
    t.string  "paywall_yn"
    t.string  "content_frequency_time"
    t.string  "content_frequence_other"
    t.string  "content_frequency_guide"
    t.string  "next_issue_yn"
  end

  add_index "medias", ["parent_id"], name: "index_medias_on_parent_id", using: :btree

  create_table "msa_infos", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "msa_infos", ["name"], name: "index_msa_infos_on_name", using: :btree

  create_table "place_categories", force: :cascade do |t|
    t.integer  "parent_id"
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "place_categories", ["parent_id"], name: "index_place_categories_on_parent_id", using: :btree

  create_table "place_category_assignments", force: :cascade do |t|
    t.integer  "places_id",           null: false
    t.integer  "place_categories_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "place_category_assignments", ["places_id", "place_categories_id"], name: "idx_place_category_assignment_ids", unique: true, using: :btree

  create_table "places", force: :cascade do |t|
    t.integer  "location_id",     null: false
    t.string   "email"
    t.string   "phone"
    t.boolean  "needs_review"
    t.boolean  "reported_closed"
    t.hstore   "aux_data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "places", ["location_id"], name: "index_places_on_location_id", using: :btree

  create_table "release_queue", force: :cascade do |t|
    t.integer "ordinal",  null: false
    t.integer "story_id", null: false
  end

  create_table "stories", force: :cascade do |t|
    t.date     "original_published_at"
    t.integer  "original_published_month"
    t.integer  "original_publish_year"
    t.date     "sap_published_at"
    t.string   "editor_tagline"
    t.boolean  "author_track"
    t.boolean  "story_ready_for_display"
    t.boolean  "story_list_complete"
    t.boolean  "track_original_published_at"
    t.boolean  "track_original_published_month"
    t.boolean  "track_original_published_day"
    t.decimal  "data_entry_time"
    t.decimal  "data_entry_user_id"
    t.integer  "media_id"
    t.string   "status"
    t.hstore   "aux_data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "story_categories", force: :cascade do |t|
    t.integer  "parent_id"
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "story_categories", ["parent_id"], name: "index_story_categories_on_parent_id", using: :btree

  create_table "story_category_assignments", force: :cascade do |t|
    t.integer  "stories_id",          null: false
    t.integer  "story_categories_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "story_category_assignments", ["stories_id", "story_categories_id"], name: "idx_place_categories_assignment_ids", unique: true, using: :btree

  create_table "story_place_assignments", force: :cascade do |t|
    t.integer  "stories_id", null: false
    t.integer  "places_id",  null: false
    t.hstore   "aux_data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "story_place_assignments", ["stories_id", "places_id"], name: "idx_story_place_assignment_ids", unique: true, using: :btree

  create_table "urls", force: :cascade do |t|
    t.string   "urlable_type",                  null: false
    t.integer  "urlable_id",                    null: false
    t.string   "full_url",                      null: false
    t.string   "domain"
    t.string   "category"
    t.string   "title"
    t.string   "description"
    t.boolean  "needs_review"
    t.boolean  "hold"
    t.boolean  "archive",       default: false
    t.text     "keywords",      default: [],                 array: true
    t.integer  "legacy_url_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "urls", ["urlable_id"], name: "index_urls_on_urlable_id", unique: true, using: :btree
  add_index "urls", ["urlable_type"], name: "index_urls_on_urlable_type", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "zip_codes", force: :cascade do |t|
    t.string   "fips_id",     null: false
    t.string   "postal_code", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "zip_codes", ["postal_code"], name: "index_zip_codes_on_postal_code", using: :btree

end
