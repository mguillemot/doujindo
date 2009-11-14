class CreateShippingPrices < ActiveRecord::Migration
  def self.up
    create_table :shipping_prices do |t|
      t.string :method, :null => false
      t.string :zone, :null => false
      t.integer :min_weight, :null => false
      t.integer :max_weight, :null => false
      t.integer :price, :null => false
    end
    add_index :shipping_prices, [ :method, :zone ]
    add_index :shipping_prices, :min_weight
    add_index :shipping_prices, :max_weight
  end

  def self.down
    drop_table :shipping_prices
  end
end
