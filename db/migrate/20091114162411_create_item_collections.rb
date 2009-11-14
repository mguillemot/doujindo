class CreateItemCollections < ActiveRecord::Migration
  def self.up
    create_table :item_collections do |t|
      t.string :title_en
      t.string :title_fr
      t.timestamps
    end
  end

  def self.down
    drop_table :item_collections
  end
end
