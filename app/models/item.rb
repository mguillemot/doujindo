class Item < ActiveRecord::Base
  belongs_to :category
  has_many :item_assets, :order => :position
  has_many :static_assets, :through => :item_assets, :order => :position
  has_many :cart_items
  has_many :order_items
  belongs_to :collection, :class_name => 'ItemCollection'
  has_and_belongs_to_many :tags, :join_table => 'item_tags'
  has_one :osusume

  translatable_columns :title, :author, :item_type, :description, :test, :required_config, :warning
  acts_as_fulltextable :title_en, :title_fr, :original_title, :author_en, :author_fr, :item_type_en, :item_type_fr, :description_en, :description_fr, :test_en, :test_fr, :required_config_en, :required_config_fr, :warning_en, :warning_fr

  validates_translation_of :title, :author, :item_type, :description
  validates_inclusion_of :dimension_width, :in => 1..2000
  validates_inclusion_of :dimension_height, :in => 1..2000
  validates_inclusion_of :dimension_thickness, :in => 1..2000
  validates_inclusion_of :weight, :in => 1..30000

  def main_thumb
    pictures.size >= 1 ? pictures[0].thumb : StaticAsset.default_catalog_icon
  end

  def pictures
    static_assets.find :all, :conditions => ['asset_type = ?', 'image']
  end

  def video
    static_assets.find :first, :conditions => ['asset_type = ?', 'video']
  end

  def video_preview
    v = video
    return nil unless v
    StaticAsset.find :first, :conditions => ['asset_type = ? AND filename = ?', 'video_preview', v.filename]
  end

  def tracklist
    res = static_assets.find :all, :conditions => ['asset_type = ?', 'audio']
    return nil if res.empty?
    res
  end

  def nav
    category.nav << [ title, { :controller => 'item', :action => 'index', :ident => ident } ]
  end

  def availability_type
    return 0 if stock == 0
    return 1 if stock_type == 'preorder'
    2
  end
end
