class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.string :ident, :null => false
      t.integer :category_id, :null => false
      t.string :title_en
      t.string :title_fr
      t.string :author_en
      t.string :author_fr
      t.string :item_type_en
      t.string :item_type_fr
      t.integer :collection_id
      t.string :package_type, :null => false, :default => 'box'
      t.integer :dimension_width, :null => false
      t.integer :dimension_height, :null => false
      t.integer :dimension_thickness
      t.integer :weight, :null => false
      t.text :description_en
      t.text :description_fr
      t.integer :stock_left_new, :null => false, :default => 0
      t.integer :stock_left_perfect_condition, :null => false, :default => 0
      t.integer :stock_left_good_condition, :null => false, :default => 0
      t.integer :stock_left_medium_condition, :null => false, :default => 0
      t.integer :stock_left_poor_condition, :null => false, :default => 0
      t.integer :purchase_left, :null => false, :default => 0
      t.integer :reservation_left, :null => false, :default => 0
      t.date :reservation_end_date
      t.integer :price, :null => false, :default => 0
      t.string :main_picture
      t.string :other_pictures
      t.string :video
      t.string :publisher_en
      t.string :publisher_fr
      t.text :tracklist_en
      t.text :tracklist_fr
      t.text :test_en
      t.text :test_fr
      t.text :required_config_en
      t.text :required_config_fr
      t.text :format_en
      t.text :format_fr
      t.text :warning_en
      t.text :warning_fr
      t.text :notes_en
      t.text :notes_fr
      t.boolean :show, :null => false, :default => false
      t.timestamps
    end
    add_index :items, :ident, :unique => true
    add_index :items, :category_id
    add_index :items, :collection_id
  end

  def self.down
    drop_table :items
  end
end
