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

ActiveRecord::Schema[7.1].define(version: 2024_03_11_210230) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "postgis"
  enable_extension "uuid-ossp"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "animes", force: :cascade do |t|
    t.string "title"
    t.integer "year"
    t.text "genres"
    t.integer "popularity"
    t.integer "average_score"
    t.integer "episodes"
    t.boolean "is_adult"
    t.string "status"
    t.string "studios"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "japanese_title"
    t.index ["japanese_title"], name: "index_animes_on_japanese_title"
  end

  create_table "blocks", force: :cascade do |t|
    t.integer "blocker_id"
    t.integer "blockee_id"
    t.bigint "report_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["blockee_id"], name: "index_blocks_on_blockee_id"
    t.index ["blocker_id"], name: "index_blocks_on_blocker_id"
    t.index ["report_id"], name: "index_blocks_on_report_id"
    t.index ["user_id"], name: "index_blocks_on_user_id"
  end

  create_table "characters", force: :cascade do |t|
    t.bigint "anime_id", null: false
    t.string "first_name"
    t.string "last_name"
    t.integer "favorites"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "japanese_full_name"
    t.index ["anime_id"], name: "index_characters_on_anime_id"
    t.index ["favorites"], name: "index_characters_on_favorites"
    t.index ["role"], name: "index_characters_on_role"
  end

  create_table "conventions", force: :cascade do |t|
    t.string "title", null: false
    t.string "venue", null: false
    t.string "country", null: false
    t.string "display_city", null: false
    t.string "display_state", null: false
    t.datetime "start_date", null: false
    t.datetime "end_date"
    t.string "website"
    t.geography "lonlat", limit: {:srid=>4326, :type=>"st_point", :geographic=>true}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "full_address", null: false
    t.index ["lonlat"], name: "index_conventions_on_lonlat"
    t.index ["start_date"], name: "index_conventions_on_start_date"
    t.index ["title"], name: "index_conventions_on_title"
  end

  create_table "conversations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "match_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_conversations_on_deleted_at"
    t.index ["match_id"], name: "index_conversations_on_match_id"
  end

  create_table "device_infos", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "device_type"
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_device_infos_on_user_id"
  end

  create_table "event_invites", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.integer "sender_id", null: false
    t.integer "receiver_id", null: false
    t.integer "status", default: 0
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_event_invites_on_event_id"
    t.index ["receiver_id"], name: "index_event_invites_on_receiver_id"
    t.index ["sender_id"], name: "index_event_invites_on_sender_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "title"
    t.datetime "start_date", null: false
    t.datetime "end_date"
    t.string "venue", null: false
    t.string "country", null: false
    t.string "display_city", null: false
    t.string "display_state", null: false
    t.geography "lonlat", limit: {:srid=>4326, :type=>"st_point", :geographic=>true}, null: false
    t.text "description"
    t.integer "host_id", null: false
    t.integer "convention_id"
    t.integer "cosplay_required", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "payment_required", default: false
    t.integer "member_limit", default: 10, null: false
    t.string "full_address", null: false
    t.index ["cosplay_required"], name: "index_events_on_cosplay_required"
    t.index ["host_id"], name: "index_events_on_host_id"
    t.index ["payment_required"], name: "index_events_on_payment_required"
    t.index ["start_date"], name: "index_events_on_start_date"
    t.index ["title"], name: "index_events_on_title"
  end

  create_table "favorite_musics", force: :cascade do |t|
    t.integer "music_type"
    t.string "cover_url"
    t.string "track_name"
    t.string "artist_name"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "spotify_id"
    t.boolean "hidden"
    t.datetime "deleted_at"
    t.index ["artist_name"], name: "index_favorite_musics_on_artist_name"
    t.index ["deleted_at"], name: "index_favorite_musics_on_deleted_at"
    t.index ["hidden"], name: "index_favorite_musics_on_hidden"
    t.index ["music_type"], name: "index_favorite_musics_on_music_type"
    t.index ["track_name"], name: "index_favorite_musics_on_track_name"
    t.index ["user_id"], name: "index_favorite_musics_on_user_id"
  end

  create_table "galleries", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_galleries_on_deleted_at"
    t.index ["user_id"], name: "index_galleries_on_user_id"
  end

  create_table "influencers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "referral_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_influencers_on_deleted_at"
    t.index ["referral_count"], name: "index_influencers_on_referral_count"
    t.index ["user_id"], name: "index_influencers_on_user_id"
  end

  create_table "join_requests", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "event_id", null: false
    t.integer "status", default: 0, null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "conversation_id"
    t.index ["event_id"], name: "index_join_requests_on_event_id"
    t.index ["user_id"], name: "index_join_requests_on_user_id"
  end

  create_table "likes", force: :cascade do |t|
    t.integer "like_type"
    t.bigint "user_id", null: false
    t.integer "likee_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_likes_on_deleted_at"
    t.index ["likee_id"], name: "index_likes_on_likee_id"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "matches", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "matchee_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_matches_on_deleted_at"
    t.index ["matchee_id"], name: "index_matches_on_matchee_id"
    t.index ["user_id"], name: "index_matches_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.integer "sender_id", null: false
    t.text "content"
    t.integer "reaction"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "conversation_id", null: false
    t.integer "sticker_id"
    t.boolean "read", default: false, null: false
    t.datetime "deleted_at"
    t.index ["conversation_id"], name: "index_messages_on_conversation_id"
    t.index ["deleted_at"], name: "index_messages_on_deleted_at"
    t.index ["sender_id"], name: "index_messages_on_sender_id"
  end

  create_table "parties", force: :cascade do |t|
    t.integer "host_id", null: false
    t.integer "event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "disbanded", default: false
    t.integer "member_limit"
    t.integer "status", default: 0, null: false
    t.index ["event_id"], name: "index_parties_on_event_id"
    t.index ["host_id"], name: "index_parties_on_host_id"
    t.index ["status"], name: "index_parties_on_status"
  end

  create_table "party_chats", force: :cascade do |t|
    t.bigint "party_id", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["party_id"], name: "index_party_chats_on_party_id"
  end

  create_table "party_messages", force: :cascade do |t|
    t.integer "sender_id"
    t.text "content"
    t.integer "reaction"
    t.bigint "party_chat_id", null: false
    t.integer "sticker_id"
    t.boolean "read"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["party_chat_id"], name: "index_party_messages_on_party_chat_id"
    t.index ["read"], name: "index_party_messages_on_read"
    t.index ["sender_id"], name: "index_party_messages_on_sender_id"
  end

  create_table "photos", force: :cascade do |t|
    t.bigint "gallery_id", null: false
    t.integer "order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_photos_on_deleted_at"
    t.index ["gallery_id"], name: "index_photos_on_gallery_id"
    t.index ["order"], name: "index_photos_on_order"
  end

  create_table "push_notifications", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "content"
    t.string "event_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_push_notifications_on_user_id"
  end

  create_table "recommendations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "recommendee_id", null: false
    t.bigint "anime_id", null: false
    t.bigint "message_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.bigint "party_message_id"
    t.index ["anime_id"], name: "index_recommendations_on_anime_id"
    t.index ["deleted_at"], name: "index_recommendations_on_deleted_at"
    t.index ["message_id"], name: "index_recommendations_on_message_id"
    t.index ["party_message_id"], name: "index_recommendations_on_party_message_id"
    t.index ["recommendee_id"], name: "index_recommendations_on_recommendee_id"
    t.index ["user_id"], name: "index_recommendations_on_user_id"
  end

  create_table "reports", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "status", default: 0, null: false
    t.integer "offense_id"
    t.integer "reason"
    t.uuid "conversation_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["conversation_id"], name: "index_reports_on_conversation_id"
    t.index ["offense_id"], name: "index_reports_on_offense_id"
    t.index ["reason"], name: "index_reports_on_reason"
    t.index ["user_id"], name: "index_reports_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.decimal "score", precision: 1, scale: 1, null: false
    t.integer "review_type", null: false
    t.string "reviewable_type", null: false
    t.bigint "reviewable_id", null: false
    t.text "feedback"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["review_type"], name: "index_reviews_on_review_type"
    t.index ["reviewable_type", "reviewable_id"], name: "index_reviews_on_reviewable"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "rpush_apps", force: :cascade do |t|
    t.string "name", null: false
    t.string "environment"
    t.text "certificate"
    t.string "password"
    t.integer "connections", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type", null: false
    t.string "auth_key"
    t.string "client_id"
    t.string "client_secret"
    t.string "access_token"
    t.datetime "access_token_expiration"
    t.text "apn_key"
    t.string "apn_key_id"
    t.string "team_id"
    t.string "bundle_id"
    t.boolean "feedback_enabled", default: true
  end

  create_table "rpush_feedback", force: :cascade do |t|
    t.string "device_token"
    t.datetime "failed_at", precision: nil, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "app_id"
    t.index ["device_token"], name: "index_rpush_feedback_on_device_token"
  end

  create_table "rpush_notifications", force: :cascade do |t|
    t.integer "badge"
    t.string "device_token"
    t.string "sound"
    t.text "alert"
    t.text "data"
    t.integer "expiry", default: 86400
    t.boolean "delivered", default: false, null: false
    t.datetime "delivered_at", precision: nil
    t.boolean "failed", default: false, null: false
    t.datetime "failed_at", precision: nil
    t.integer "error_code"
    t.text "error_description"
    t.datetime "deliver_after", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "alert_is_json", default: false, null: false
    t.string "type", null: false
    t.string "collapse_key"
    t.boolean "delay_while_idle", default: false, null: false
    t.text "registration_ids"
    t.integer "app_id", null: false
    t.integer "retries", default: 0
    t.string "uri"
    t.datetime "fail_after", precision: nil
    t.boolean "processing", default: false, null: false
    t.integer "priority"
    t.text "url_args"
    t.string "category"
    t.boolean "content_available", default: false, null: false
    t.text "notification"
    t.boolean "mutable_content", default: false, null: false
    t.string "external_device_id"
    t.string "thread_id"
    t.boolean "dry_run", default: false, null: false
    t.boolean "sound_is_json", default: false
    t.index ["delivered", "failed", "processing", "deliver_after", "created_at"], name: "index_rpush_notifications_multi", where: "((NOT delivered) AND (NOT failed))"
  end

  create_table "stickers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_animes", force: :cascade do |t|
    t.integer "user_id"
    t.integer "anime_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "order"
    t.datetime "deleted_at"
    t.index ["anime_id"], name: "index_user_animes_on_anime_id"
    t.index ["deleted_at"], name: "index_user_animes_on_deleted_at"
    t.index ["order"], name: "index_user_animes_on_order"
    t.index ["user_id"], name: "index_user_animes_on_user_id"
  end

  create_table "user_conventions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "convention_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["convention_id"], name: "index_user_conventions_on_convention_id"
    t.index ["user_id"], name: "index_user_conventions_on_user_id"
  end

  create_table "user_conversations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.uuid "conversation_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["conversation_id"], name: "index_user_conversations_on_conversation_id"
    t.index ["deleted_at"], name: "index_user_conversations_on_deleted_at"
    t.index ["user_id"], name: "index_user_conversations_on_user_id"
  end

  create_table "user_parties", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "party_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["party_id"], name: "index_user_parties_on_party_id"
    t.index ["user_id"], name: "index_user_parties_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "phone", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.integer "gender"
    t.integer "desired_gender"
    t.boolean "premium", default: false, null: false
    t.integer "role", default: 0, null: false
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.text "bio", default: "", null: false
    t.boolean "verified", default: false, null: false
    t.string "school", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.string "first_name"
    t.string "occupation"
    t.string "display_city"
    t.string "display_state"
    t.datetime "birthday"
    t.integer "online_status", default: 1
    t.geography "lonlat", limit: {:srid=>4326, :type=>"st_point", :geographic=>true}
    t.integer "super_like_count", default: 5
    t.boolean "banned", default: false
    t.integer "warning_count", default: 0
    t.boolean "has_location_hidden"
    t.datetime "next_payment_date"
    t.string "country"
    t.boolean "is_fake_profile", default: false
    t.boolean "is_displaying_active", default: true
    t.boolean "is_displaying_recently_active", default: true
    t.index ["birthday"], name: "index_users_on_birthday"
    t.index ["country"], name: "index_users_on_country"
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["has_location_hidden"], name: "index_users_on_has_location_hidden"
    t.index ["is_fake_profile"], name: "index_users_on_is_fake_profile"
    t.index ["online_status"], name: "index_users_on_online_status"
    t.index ["phone"], name: "index_users_on_phone", unique: true
    t.index ["premium"], name: "index_users_on_premium"
    t.index ["super_like_count"], name: "index_users_on_super_like_count"
  end

  create_table "verify_requests", force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_verify_requests_on_deleted_at"
    t.index ["status"], name: "index_verify_requests_on_status"
    t.index ["user_id"], name: "index_verify_requests_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "blocks", "reports"
  add_foreign_key "blocks", "users"
  add_foreign_key "characters", "animes"
  add_foreign_key "conversations", "matches"
  add_foreign_key "device_infos", "users"
  add_foreign_key "event_invites", "events"
  add_foreign_key "favorite_musics", "users"
  add_foreign_key "galleries", "users"
  add_foreign_key "influencers", "users"
  add_foreign_key "join_requests", "events"
  add_foreign_key "join_requests", "users"
  add_foreign_key "likes", "users"
  add_foreign_key "matches", "users"
  add_foreign_key "messages", "conversations"
  add_foreign_key "party_chats", "parties"
  add_foreign_key "party_messages", "party_chats"
  add_foreign_key "photos", "galleries"
  add_foreign_key "push_notifications", "users"
  add_foreign_key "recommendations", "animes"
  add_foreign_key "recommendations", "messages"
  add_foreign_key "recommendations", "party_messages"
  add_foreign_key "recommendations", "users"
  add_foreign_key "reports", "conversations"
  add_foreign_key "reports", "users"
  add_foreign_key "reviews", "users"
  add_foreign_key "user_conventions", "conventions"
  add_foreign_key "user_conventions", "users"
  add_foreign_key "user_conversations", "conversations"
  add_foreign_key "user_conversations", "users"
  add_foreign_key "user_parties", "parties"
  add_foreign_key "user_parties", "users"
  add_foreign_key "verify_requests", "users"
end
