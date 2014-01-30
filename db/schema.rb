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

ActiveRecord::Schema.define(version: 20140130132755) do

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

  create_table "categories", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.string   "wikipedia_title"
    t.text     "raw_content"
    t.text     "cooked_content"
    t.string   "ancestry"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["ancestry"], name: "index_categories_on_ancestry", using: :btree
  add_index "categories", ["slug"], name: "index_categories_on_slug", unique: true, using: :btree

  create_table "collections", force: true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.boolean  "public",            default: true
    t.string   "ancestry"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "impressions_count", default: 0
  end

  add_index "collections", ["ancestry"], name: "index_collections_on_ancestry", using: :btree
  add_index "collections", ["user_id"], name: "index_collections_on_user_id", using: :btree

  create_table "colors", force: true do |t|
    t.integer "red"
    t.integer "green"
    t.integer "blue"
    t.string  "hex"
  end

  add_index "colors", ["hex"], name: "index_colors_on_hex", unique: true, using: :btree

  create_table "comments", force: true do |t|
    t.string   "title",            limit: 50, default: ""
    t.text     "comment"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.string   "role",                        default: "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "cooked_comment"
  end

  add_index "comments", ["commentable_id"], name: "index_comments_on_commentable_id", using: :btree
  add_index "comments", ["commentable_type"], name: "index_comments_on_commentable_type", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "favourites", force: true do |t|
    t.integer  "user_id"
    t.integer  "wallpaper_id"
    t.integer  "collection_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "favourites", ["collection_id"], name: "index_favourites_on_collection_id", using: :btree
  add_index "favourites", ["user_id"], name: "index_favourites_on_user_id", using: :btree
  add_index "favourites", ["wallpaper_id"], name: "index_favourites_on_wallpaper_id", using: :btree

  create_table "forum_topics", force: true do |t|
    t.integer  "forum_id"
    t.integer  "user_id"
    t.string   "title"
    t.text     "content"
    t.text     "cooked_content"
    t.boolean  "pinned",         default: false
    t.boolean  "locked",         default: false
    t.boolean  "hidden",         default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "forum_topics", ["forum_id"], name: "index_forum_topics_on_forum_id", using: :btree
  add_index "forum_topics", ["user_id"], name: "index_forum_topics_on_user_id", using: :btree

  create_table "forums", force: true do |t|
    t.integer  "group_id"
    t.string   "name"
    t.string   "slug"
    t.text     "description"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "guest_can_read",   default: true
    t.boolean  "guest_can_post",   default: true
    t.boolean  "guest_can_reply",  default: true
    t.boolean  "member_can_read",  default: true
    t.boolean  "member_can_post",  default: true
    t.boolean  "member_can_reply", default: true
  end

  add_index "forums", ["group_id"], name: "index_forums_on_group_id", using: :btree
  add_index "forums", ["slug"], name: "index_forums_on_slug", using: :btree

  create_table "groups", force: true do |t|
    t.integer  "owner_id"
    t.string   "name"
    t.string   "slug"
    t.text     "description"
    t.string   "admin_title"
    t.string   "moderator_title"
    t.string   "member_title"
    t.boolean  "has_forums"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "tagline"
    t.string   "access"
    t.boolean  "official",        default: false
  end

  add_index "groups", ["access"], name: "index_groups_on_access", using: :btree
  add_index "groups", ["owner_id"], name: "index_groups_on_owner_id", using: :btree
  add_index "groups", ["slug"], name: "index_groups_on_slug", unique: true, using: :btree

  create_table "impressions", force: true do |t|
    t.string   "impressionable_type"
    t.integer  "impressionable_id"
    t.integer  "user_id"
    t.string   "controller_name"
    t.string   "action_name"
    t.string   "view_name"
    t.string   "request_hash"
    t.string   "ip_address"
    t.string   "session_hash"
    t.text     "message"
    t.text     "referrer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "impressions", ["controller_name", "action_name", "ip_address"], name: "controlleraction_ip_index", using: :btree
  add_index "impressions", ["controller_name", "action_name", "request_hash"], name: "controlleraction_request_index", using: :btree
  add_index "impressions", ["controller_name", "action_name", "session_hash"], name: "controlleraction_session_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "ip_address"], name: "poly_ip_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "request_hash"], name: "poly_request_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "session_hash"], name: "poly_session_index", using: :btree
  add_index "impressions", ["impressionable_type", "message", "impressionable_id"], name: "impressionable_type_message_index", using: :btree
  add_index "impressions", ["user_id"], name: "index_impressions_on_user_id", using: :btree

  create_table "oauth_access_grants", force: true do |t|
    t.integer  "resource_owner_id",              null: false
    t.integer  "application_id",                 null: false
    t.string   "token",                          null: false
    t.integer  "expires_in",                     null: false
    t.string   "redirect_uri",      limit: 2048, null: false
    t.datetime "created_at",                     null: false
    t.datetime "revoked_at"
    t.string   "scopes"
  end

  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree

  create_table "oauth_access_tokens", force: true do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id",    null: false
    t.string   "token",             null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",        null: false
    t.string   "scopes"
  end

  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree

  create_table "oauth_applications", force: true do |t|
    t.string   "name",                      null: false
    t.string   "uid",                       null: false
    t.string   "secret",                    null: false
    t.string   "redirect_uri", limit: 2048, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree

  create_table "reports", force: true do |t|
    t.integer  "reportable_id"
    t.string   "reportable_type"
    t.integer  "user_id"
    t.text     "description"
    t.integer  "closed_by_id"
    t.datetime "closed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reports", ["closed_by_id"], name: "index_reports_on_closed_by_id", using: :btree
  add_index "reports", ["reportable_id", "reportable_type"], name: "index_reports_on_reportable_id_and_reportable_type", using: :btree
  add_index "reports", ["user_id"], name: "index_reports_on_user_id", using: :btree

  create_table "roles", force: true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "screen_resolutions", force: true do |t|
    t.integer "width"
    t.integer "height"
    t.string  "category"
  end

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: true do |t|
    t.string "name"
  end

  create_table "user_profiles", force: true do |t|
    t.integer  "user_id"
    t.integer  "cover_wallpaper_id"
    t.integer  "cover_wallpaper_y_offset"
    t.string   "country_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username_color_hex"
    t.string   "title"
  end

  add_index "user_profiles", ["cover_wallpaper_id"], name: "index_user_profiles_on_cover_wallpaper_id", using: :btree
  add_index "user_profiles", ["user_id"], name: "index_user_profiles_on_user_id", unique: true, using: :btree

  create_table "user_settings", force: true do |t|
    t.integer  "user_id"
    t.boolean  "sfw",                  default: true
    t.boolean  "sketchy",              default: false
    t.boolean  "nsfw",                 default: false
    t.integer  "per_page",             default: 20
    t.boolean  "infinite_scroll",      default: true
    t.integer  "screen_width"
    t.integer  "screen_height"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "screen_resolution_id"
  end

  add_index "user_settings", ["screen_resolution_id"], name: "index_user_settings_on_screen_resolution_id", using: :btree
  add_index "user_settings", ["user_id"], name: "index_user_settings_on_user_id", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.integer  "discourse_user_id"
    t.integer  "wallpapers_count",       default: 0
    t.boolean  "moderator",              default: false
    t.boolean  "admin",                  default: false
    t.boolean  "developer",              default: false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,     null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "authentication_token"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["discourse_user_id"], name: "index_users_on_discourse_user_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  create_table "users_groups", force: true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role"
  end

  add_index "users_groups", ["group_id"], name: "index_users_groups_on_group_id", using: :btree
  add_index "users_groups", ["role"], name: "index_users_groups_on_role", using: :btree
  add_index "users_groups", ["user_id"], name: "index_users_groups_on_user_id", using: :btree

  create_table "users_roles", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

  create_table "versions", force: true do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

  create_table "votes", force: true do |t|
    t.integer  "votable_id"
    t.string   "votable_type"
    t.integer  "voter_id"
    t.string   "voter_type"
    t.boolean  "vote_flag"
    t.string   "vote_scope"
    t.integer  "vote_weight"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope", using: :btree
  add_index "votes", ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope", using: :btree

  create_table "wallpaper_colors", force: true do |t|
    t.integer "wallpaper_id"
    t.integer "color_id"
    t.float   "percentage"
  end

  add_index "wallpaper_colors", ["color_id"], name: "index_wallpaper_colors_on_color_id", using: :btree
  add_index "wallpaper_colors", ["wallpaper_id"], name: "index_wallpaper_colors_on_wallpaper_id", using: :btree

  create_table "wallpapers", force: true do |t|
    t.integer  "user_id"
    t.string   "purity"
    t.boolean  "processing",                    default: true
    t.string   "image_uid"
    t.string   "image_name"
    t.integer  "image_width"
    t.integer  "image_height"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "thumbnail_image_uid"
    t.integer  "primary_color_id"
    t.integer  "impressions_count",             default: 0
    t.text     "cached_tag_list"
    t.string   "image_gravity",                 default: "c"
    t.integer  "favourites_count",              default: 0
    t.boolean  "purity_locked",                 default: false
    t.string   "source"
    t.integer  "phash",               limit: 8
    t.string   "scrape_source"
    t.string   "scrape_id"
    t.string   "image_hash"
    t.integer  "category_id"
  end

  add_index "wallpapers", ["category_id"], name: "index_wallpapers_on_category_id", using: :btree
  add_index "wallpapers", ["image_hash"], name: "index_wallpapers_on_image_hash", using: :btree
  add_index "wallpapers", ["phash"], name: "index_wallpapers_on_phash", using: :btree
  add_index "wallpapers", ["primary_color_id"], name: "index_wallpapers_on_primary_color_id", using: :btree
  add_index "wallpapers", ["scrape_source", "scrape_id"], name: "index_wallpapers_on_scrape_source_and_scrape_id", unique: true, using: :btree
  add_index "wallpapers", ["user_id"], name: "index_wallpapers_on_user_id", using: :btree

end
