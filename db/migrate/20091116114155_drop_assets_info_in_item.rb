class DropAssetsInfoInItem < ActiveRecord::Migration
  def self.up
    remove_columns :items, :main_picture_id, :other_pictures, :video_id, :tracklist
  end

  def self.down
    raise 'Impossible to roll back this migration'
  end
end
