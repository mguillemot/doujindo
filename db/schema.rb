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
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.integer  "parent_id"
    t.string   "ident"
    t.string   "title_en"
    t.string   "title_fr"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "currencies", :force => true do |t|
    t.string   "description_en"
    t.string   "description_fr"
    t.string   "symbol",                                                      :null => false
    t.string   "format_en"
    t.string   "format_fr"
    t.integer  "rate_to_yen",    :limit => 10, :precision => 10, :scale => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", :force => true do |t|
    t.string   "title_en"
    t.string   "title_fr"
    t.string   "ident",                :limit => 16,                   :null => false
    t.integer  "category_id",                                          :null => false
    t.string   "author_en"
    t.string   "author_fr"
    t.string   "item_type_en"
    t.string   "item_type_fr"
    t.text     "description_en"
    t.text     "description_fr"
    t.integer  "stock_left"
    t.integer  "purchase_left"
    t.integer  "reservation_left"
    t.date     "reservation_end_date"
    t.integer  "price",                              :default => 0,    :null => false
    t.string   "main_picture"
    t.string   "other_pictures"
    t.string   "video"
    t.string   "publisher_en"
    t.string   "publisher_fr"
    t.text     "tracklist_en"
    t.text     "tracklist_fr"
    t.text     "test_en"
    t.text     "test_fr"
    t.text     "required_config_en"
    t.text     "required_config_fr"
    t.text     "format_en"
    t.text     "format_fr"
    t.text     "warning_en"
    t.text     "warning_fr"
    t.text     "notes_en"
    t.text     "notes_fr"
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
    t.string   "login",                                      :null => false
    t.string   "password_hash",                              :null => false
    t.string   "password_salt",                              :null => false
    t.string   "first_name",                                 :null => false
    t.string   "last_name",                                  :null => false
    t.string   "email",                                      :null => false
    t.string   "email_confirmation_key"
    t.datetime "email_confirmation_date"
    t.boolean  "admin",                   :default => false, :null => false
    t.integer  "login_count",             :default => 0,     :null => false
    t.datetime "last_login"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
