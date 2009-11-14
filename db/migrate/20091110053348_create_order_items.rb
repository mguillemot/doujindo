class CreateOrderItems < ActiveRecord::Migration
  def self.up
    create_table :order_items do |t|
      t.integer :order_id, :null => false
      t.integer :item_id, :null => false
      t.integer :quantity, :null => false, :default => 1
      t.decimal :unit_price, :null => false, :precision => 8, :scale => 2
      t.decimal :total_price, :null => false, :precision => 8, :scale => 2
      t.timestamps
    end
    add_index :order_items, :order_id
  end

  def self.down
    drop_table :order_items
  end
end
