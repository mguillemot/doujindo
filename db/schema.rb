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

ActiveRecord::Schema.define(:version => 20091217054723) do

  create_table "blog_posts", :force => true do |t|
    t.string   "ident",      :null => false
    t.integer  "author_id",  :null => false
    t.string   "title_en"
    t.string   "title_fr"
    t.text     "content_en"
    t.text     "content_fr"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "blog_posts", ["ident"], :name => "index_blog_posts_on_ident", :unique => true

  create_table "cart_items", :force => true do |t|
    t.integer  "cart_id",                   :null => false
    t.integer  "item_id",                   :null => false
    t.integer  "quantity",   :default => 1, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cart_items", ["cart_id"], :name => "index_cart_items_on_cart_id"

  create_table "carts", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.integer  "parent_id"
    t.string   "ident",      :null => false
    t.string   "title_en"
    t.string   "title_fr"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["ident"], :name => "index_categories_on_ident", :unique => true

  create_table "countries", :force => true do |t|
    t.string "name_en",         :null => false
    t.string "name_fr",         :null => false
    t.string "ems_zone"
    t.string "sal_zone"
    t.string "geographic_zone", :null => false
    t.string "note"
    t.string "paypal_code"
  end

  add_index "countries", ["paypal_code"], :name => "index_countries_on_paypal_code"

  create_table "currencies", :force => true do |t|
    t.string   "description_en",                               :null => false
    t.string   "description_fr",                               :null => false
    t.string   "symbol",                                       :null => false
    t.string   "format_en",                                    :null => false
    t.string   "format_fr",                                    :null => false
    t.decimal  "rate_to_yen",    :precision => 8, :scale => 2, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "paypal_code"
  end

  create_table "item_assets", :force => true do |t|
    t.integer  "item_id",         :null => false
    t.integer  "static_asset_id", :null => false
    t.integer  "position",        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "item_assets", ["item_id"], :name => "index_item_assets_on_item_id"
  add_index "item_assets", ["static_asset_id"], :name => "index_item_assets_on_static_asset_id"

  create_table "item_collections", :force => true do |t|
    t.string   "title_en"
    t.string   "title_fr"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "item_tags", :id => false, :force => true do |t|
    t.integer "item_id", :null => false
    t.integer "tag_id",  :null => false
  end

  add_index "item_tags", ["item_id"], :name => "index_item_tags_on_item_id"
  add_index "item_tags", ["tag_id"], :name => "index_item_tags_on_tag_id"

  create_table "items", :force => true do |t|
    t.string   "ident",                                   :null => false
    t.integer  "category_id",                             :null => false
    t.string   "title_en"
    t.string   "title_fr"
    t.string   "original_title"
    t.string   "author_en"
    t.string   "author_fr"
    t.string   "item_type_en"
    t.string   "item_type_fr"
    t.integer  "collection_id"
    t.string   "package_type",         :default => "box", :null => false
    t.integer  "dimension_width",                         :null => false
    t.integer  "dimension_height",                        :null => false
    t.integer  "dimension_thickness"
    t.integer  "weight",                                  :null => false
    t.text     "description_en"
    t.text     "description_fr"
    t.date     "reservation_end_date"
    t.integer  "price",                :default => 0,     :null => false
    t.text     "test_en"
    t.text     "test_fr"
    t.text     "required_config_en"
    t.text     "required_config_fr"
    t.text     "warning_en"
    t.text     "warning_fr"
    t.boolean  "show",                 :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "stock",                :default => 0,     :null => false
    t.string   "stock_type",           :default => "new", :null => false
  end

  add_index "items", ["category_id"], :name => "index_items_on_category_id"
  add_index "items", ["collection_id"], :name => "index_items_on_collection_id"
  add_index "items", ["ident"], :name => "index_items_on_ident", :unique => true

  create_table "order_items", :force => true do |t|
    t.integer  "order_id",                                                 :null => false
    t.integer  "item_id",                                                  :null => false
    t.integer  "quantity",                                  :default => 1, :null => false
    t.decimal  "unit_price",  :precision => 8, :scale => 2,                :null => false
    t.decimal  "total_price", :precision => 8, :scale => 2,                :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "order_items", ["order_id"], :name => "index_order_items_on_order_id"

  create_table "orders", :force => true do |t|
    t.integer  "client_id",                                              :null => false
    t.integer  "currency_id",                                            :null => false
    t.decimal  "items_total_price",        :precision => 8, :scale => 2, :null => false
    t.text     "notes"
    t.string   "shipping_type"
    t.decimal  "shipping_price",           :precision => 8, :scale => 2
    t.string   "shipping_status"
    t.datetime "shipping_sent_date"
    t.string   "shipping_tracking_number"
    t.string   "payment_type"
    t.string   "payment_status"
    t.datetime "payment_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ship_to_name"
    t.string   "ship_to_street"
    t.string   "ship_to_zip"
    t.string   "ship_to_city"
    t.string   "ship_to_state"
    t.integer  "ship_to_country_id"
    t.string   "paypal_token"
    t.string   "paypal_payer_id"
    t.string   "ship_to_country_code"
    t.string   "paypal_transaction_id"
  end

  add_index "orders", ["client_id"], :name => "index_orders_on_client_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "shipping_prices", :force => true do |t|
    t.string  "method",     :null => false
    t.string  "zone",       :null => false
    t.integer "min_weight", :null => false
    t.integer "max_weight", :null => false
    t.integer "price",      :null => false
  end

  add_index "shipping_prices", ["max_weight"], :name => "index_shipping_prices_on_max_weight"
  add_index "shipping_prices", ["method", "zone"], :name => "index_shipping_prices_on_method_and_zone"
  add_index "shipping_prices", ["min_weight"], :name => "index_shipping_prices_on_min_weight"

  create_table "static_assets", :force => true do |t|
    t.string   "asset_type",                 :null => false
    t.string   "mime_type",                  :null => false
    t.string   "filename",                   :null => false
    t.integer  "width"
    t.integer  "height"
    t.integer  "length"
    t.integer  "quality"
    t.integer  "filesize"
    t.string   "notes"
    t.string   "title_en",   :default => "", :null => false
    t.string   "title_fr",   :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "static_assets", ["asset_type"], :name => "index_static_assets_on_asset_type"

  create_table "tags", :force => true do |t|
    t.string   "title_en"
    t.string   "title_fr"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                                      :null => false
    t.string   "password_hash",                              :null => false
    t.string   "password_salt",                              :null => false
    t.string   "email",                                      :null => false
    t.string   "preferred_language"
    t.integer  "preferred_currency"
    t.string   "email_confirmation_key"
    t.datetime "email_confirmation_date"
    t.boolean  "admin",                   :default => false, :null => false
    t.integer  "login_count",             :default => 0,     :null => false
    t.datetime "last_login"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "lost_password_key"
    t.datetime "lost_password_date"
  end

  add_index "users", ["login"], :name => "index_users_on_login"

end
