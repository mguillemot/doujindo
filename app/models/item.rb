class Item < ActiveRecord::Base
  belongs_to :category
  has_many :item_assets, :order => :position
  has_many :static_assets, :through => :item_assets
  has_many :cart_items
  has_many :order_items
  belongs_to :collection, :class_name => 'ItemCollection'
  has_and_belongs_to_many :tags, :join_table => 'item_tags'

  translatable_columns :title, :author, :item_type, :description, :publisher, :test, :required_config, :format, :warning, :notes
  validates_translation_of :title, :author, :item_type, :description

  def main_picture
    static_assets.find :first, :conditions => ['asset_type = ?', 'icon']
  end

  def tracklist
    res = static_assets.find :all, :conditions => ['asset_type = ?', 'audio']
    return nil if res.empty?
    res
  end

  def nav
    category.nav << [ title, { :controller => 'item', :action => 'index', :id => id } ]
  end

  def max_order
    stock_left_new + stock_left_perfect_condition + stock_left_good_condition + stock_left_medium_condition + stock_left_poor_condition + purchase_left + reservation_left
  end
end
