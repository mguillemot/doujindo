class ChangeItemAssetsTypes < ActiveRecord::Migration
  def self.up
    remove_columns :items, :main_picture, :video
    add_column :items, :main_picture_id, :integer
    add_column :items, :video_id, :integer
    change_column :items, :other_pictures, :text
  end

  def self.down
    raise 'Impossible to roll back this migration'
  end
end
