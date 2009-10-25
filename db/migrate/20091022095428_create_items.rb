class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.string :ident
      t.integer :category_id
      t.string :title
      t.integer :stock
      t.integer :price
      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
