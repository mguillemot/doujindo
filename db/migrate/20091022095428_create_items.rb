class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.string :title_en
      t.string :title_fr
      t.string :ident, :null => false, :limit => 16
      t.integer :category_id, :null => false
      t.string :author_en
      t.string :author_fr
      t.string :item_type_en
      t.string :item_type_fr
      t.text :description_en
      t.text :description_fr
      t.integer :stock_left
      t.integer :purchase_left
      t.integer :reservation_left
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
      t.boolean :show, :null => false, :default => true
      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
