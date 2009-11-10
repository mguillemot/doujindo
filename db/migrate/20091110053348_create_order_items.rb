class CreateOrderItems < ActiveRecord::Migration
  def self.up
    create_table :order_items do |t|
      t.integer :order_id, :null => false
      t.integer :item_id, :null => false
      t.integer :quantity, :null => false, :default => 1
      t.decimal :unit_price, :null => false
      t.decimal :total_price, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :order_items
  end
end
