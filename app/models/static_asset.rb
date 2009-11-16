class StaticAsset < ActiveRecord::Base
  has_many :item_assets

  translatable_columns :title

  def full_filename
    "/#{asset_type}/#{filename}.#{format}"
  end

  def self.default_catalog_icon
    find 2
  end
end
