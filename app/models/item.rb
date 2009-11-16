class Item < ActiveRecord::Base
  serialize :other_pictures
  serialize :tracklist
  belongs_to :category
  belongs_to :main_picture, :class_name => 'StaticAsset'
  belongs_to :video, :class_name => 'StaticAsset'
  has_many :cart_items
  has_many :order_items
  belongs_to :collection, :class_name => 'ItemCollection'
  has_and_belongs_to_many :tags, :join_table => 'item_tags'

  translatable_columns :title, :author, :item_type, :description, :publisher, :test, :required_config, :format, :warning, :notes
  validates_translation_of :title, :author, :item_type, :description

  def nav
    category.nav << [ title, { :controller => 'item', :action => 'index', :id => id } ]
  end

  def max_order
    stock_left_new + stock_left_perfect_condition + stock_left_good_condition + stock_left_medium_condition + stock_left_poor_condition + purchase_left + reservation_left
  end
end
