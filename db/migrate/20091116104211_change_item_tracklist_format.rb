class ChangeItemTracklistFormat < ActiveRecord::Migration
  def self.up
    remove_columns :items, :tracklist_en, :tracklist_fr
    add_column :items, :tracklist, :text
  end

  def self.down
    raise 'Impossible to roll back this migration'
  end
end
