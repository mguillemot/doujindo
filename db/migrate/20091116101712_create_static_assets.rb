class CreateStaticAssets < ActiveRecord::Migration
  def self.up
    create_table :static_assets do |t|
      t.string :asset_type, :null => false
      t.string :format, :null => false
      t.string :filename, :null => false
      t.integer :width
      t.integer :height
      t.integer :length
      t.integer :quality
      t.integer :filesize
      t.string :notes
      t.string :title_en, :null => false, :default => ''
      t.string :title_fr, :null => false, :default => ''
      t.timestamps
    end
    add_index :static_assets, :asset_type
  end

  def self.down
    drop_table :static_assets
  end
end
