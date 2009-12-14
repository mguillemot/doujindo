class AddOriginalTitleToItems < ActiveRecord::Migration
  def self.up
    add_column :items, :original_title, :string
  end

  def self.down
    raise 'Impossible to roll back this migration'
  end
end
