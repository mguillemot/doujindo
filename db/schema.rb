# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20091028145928) do

  create_table "cart_items", :force => true do |t|
    t.integer  "cart_id"
    t.integer  "item_id"
    t.integer  "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "carts", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.integer  "parent_id"
    t.string   "ident"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "currencies", :force => true do |t|
    t.string   "description",                                              :null => false
    t.string   "symbol",                                                   :null => false
    t.integer  "rate_to_yen", :limit => 10, :precision => 10, :scale => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", :force => true do |t|
    t.string   "title",                                                :null => false
    t.string   "ident",                :limit => 16,                   :null => false
    t.integer  "category_id",                                          :null => false
    t.string   "author",                                               :null => false
    t.string   "item_type",                                            :null => false
    t.text     "description",                                          :null => false
    t.integer  "stock_left"
    t.integer  "purchase_left"
    t.integer  "reservation_left"
    t.date     "reservation_end_date"
    t.integer  "price",                              :default => 0,    :null => false
    t.string   "main_picture"
    t.string   "other_pictures"
    t.string   "video"
    t.string   "publisher"
    t.text     "tracklist"
    t.text     "test"
    t.text     "required_config"
    t.text     "format"
    t.text     "warning"
    t.text     "notes"
    t.boolean  "show",                               :default => true, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_addresses", :force => true do |t|
    t.integer  "user_id",          :null => false
    t.string   "full_address",     :null => false
    t.string   "country",          :null => false
    t.string   "phone_number"
    t.string   "additional_infos"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                                  :null => false
    t.string   "password_hash",                          :null => false
    t.string   "password_salt",                          :null => false
    t.string   "first_name",                             :null => false
    t.string   "last_name",                              :null => false
    t.string   "email",                                  :null => false
    t.string   "email_confirmation_key"
    t.datetime "email_confirmation_date"
    t.integer  "login_count",             :default => 0, :null => false
    t.datetime "last_login"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
