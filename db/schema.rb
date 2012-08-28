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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120816000646) do

  create_table "bookmarks", :id => false, :force => true do |t|
    t.string   "id",         :limit => 7, :null => false
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.datetime "deleted_at"
    t.string   "user_id"
    t.string   "video_id"
  end

  add_index "bookmarks", ["deleted_at"], :name => "index_bookmarks_on_deleted_at"
  add_index "bookmarks", ["id"], :name => "index_bookmarks_on_id", :unique => true
  add_index "bookmarks", ["user_id"], :name => "index_bookmarks_on_user_id"
  add_index "bookmarks", ["video_id"], :name => "index_bookmarks_on_video_id"

  create_table "users", :id => false, :force => true do |t|
    t.string   "id",              :limit => 7, :null => false
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.datetime "deleted_at"
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "fb_uid"
    t.string   "fb_access_token"
    t.string   "tw_uid"
    t.string   "tw_access_token"
  end

  add_index "users", ["deleted_at"], :name => "index_users_on_deleted_at"
  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["fb_uid"], :name => "index_users_on_fb_uid"
  add_index "users", ["id"], :name => "index_users_on_id", :unique => true
  add_index "users", ["tw_uid"], :name => "index_users_on_tw_uid"

  create_table "videos", :id => false, :force => true do |t|
    t.string   "id",            :limit => 7,    :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.datetime "deleted_at"
    t.string   "host_url",      :limit => 2048, :null => false
    t.string   "title",         :limit => 1024
    t.text     "description"
    t.text     "html"
    t.integer  "width"
    t.integer  "height"
    t.string   "thumbnail_url", :limit => 1024
  end

  add_index "videos", ["deleted_at"], :name => "index_videos_on_deleted_at"
  add_index "videos", ["host_url"], :name => "index_videos_on_host_url", :unique => true
  add_index "videos", ["id"], :name => "index_videos_on_id", :unique => true

end
