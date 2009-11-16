class CreateItemAssets < ActiveRecord::Migration
  def self.up
    create_table :item_assets do |t|
      t.integer :item_id, :null => false
      t.integer :static_asset_id, :null => false
      t.integer :position, :null => false
      t.timestamps
    end
    add_index :item_assets, :item_id
    add_index :item_assets, :static_asset_id
  end

  def self.down
    drop_table :item_assets
  end
end
