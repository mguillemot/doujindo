class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.string :title, :null => false
      t.string :ident, :null => false, :limit => 16
      t.integer :category_id, :null => false
      t.string :author, :null => false
      t.string :item_type, :null => false
      t.text :description, :null => false
      t.string :stock_type, :null => false, :default => 'unavailable'
      t.integer :current_stock
      t.integer :max_purchase
      t.date :reservation_end
      t.integer :price, :null => false, :default => 0
      t.string :main_picture
      t.string :other_pictures
      t.string :video
      t.string :publisher
      t.text :tracklist
      t.text :test
      t.text :required_config
      t.text :format
      t.text :warning
      t.text :notes
      t.boolean :show, :null => false, :default => true
      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
