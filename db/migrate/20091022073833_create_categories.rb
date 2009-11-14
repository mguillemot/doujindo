class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.integer :parent_id
      t.string :ident, :null => false
      t.string :title_en
      t.string :title_fr
      t.timestamps
    end
    add_index :categories, :ident, :unique => true
  end

  def self.down
    drop_table :categories
  end
end
