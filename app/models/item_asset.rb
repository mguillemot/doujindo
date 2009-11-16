class ItemAsset < ActiveRecord::Base
  belongs_to :item
  belongs_to :static_asset
  acts_as_list :scope => :item
end
