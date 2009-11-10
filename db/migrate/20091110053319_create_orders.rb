class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.integer :client_id, :null => false
      t.integer :shipping_address_id, :null => false
      t.integer :currency_id, :null => false
      t.decimal :items_total_price, :null => false
      t.string :shipping_type, :null => false
      t.decimal :shipping_price, :null => false
      t.string :payment_type, :null => false
      t.string :payment_status, :null => false
      t.datetime :payment_date
      t.string :payment_id
      t.string :payment_from
      t.text :notes
      t.string :shipping_status, :null => false
      t.datetime :shipping_sent_date
      t.string :shipping_tracking_id
      t.timestamps
    end
  end

  def self.down
    drop_table :orders
  end
end
