class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.integer :parent_id
      t.string :ident
      t.string :title_en
      t.string :title_fr
      t.timestamps
    end
  end

  def self.down
    drop_table :categories
  end
end
