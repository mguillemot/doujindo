class StaticAsset < ActiveRecord::Base
  has_many :item_assets

  translatable_columns :title

  def full_filename
    "/#{asset_type}/#{filename}"
  end

  def thumb
    StaticAsset.find_by_filename_and_asset_type filename, 'thumb'
  end

  def self.default_catalog_icon
    find 1
  end

  def self.valid_images
    StaticAsset.find_all_by_asset_type('image').select { |i| i.thumb != nil }
  end
end
