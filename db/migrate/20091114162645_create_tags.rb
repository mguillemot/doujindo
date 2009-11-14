class CreateTags < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.string :title_en
      t.string :title_fr
      t.timestamps
    end

    # Join table with items
    create_table :item_tags, :id => false do |t|
      t.integer :item_id, :null => false
      t.integer :tag_id, :null => false
    end
    add_index :item_tags, :item_id
    add_index :item_tags, :tag_id
  end

  def self.down
    drop_table :tags
    drop_table :item_tags
  end
end
