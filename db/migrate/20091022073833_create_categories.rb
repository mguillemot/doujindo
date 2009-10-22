class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.integer :parent
      t.string :ident
      t.string :title
      t.timestamps
    end
  end

  def self.down
    drop_table :categories
  end
end
