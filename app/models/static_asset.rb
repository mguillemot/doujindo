class StaticAsset < ActiveRecord::Base
  has_one :item, :foreign_key => 'main_picture_id'
  has_one :item, :foreign_key => 'video_id'

  translatable_columns :title

  def full_filename
    "/#{asset_type}/#{filename}.#{format}"
  end

  def self.default_catalog_icon
    find 2
  end
end
