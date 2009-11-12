class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.integer :client_id, :null => false
      t.integer :shipping_address_id
      t.integer :currency_id, :null => false
      t.decimal :items_total_price, :null => false
      t.text :notes
      t.string :shipping_type
      t.decimal :shipping_price
      t.string :shipping_status
      t.datetime :shipping_sent_date
      t.string :shipping_tracking_id
      t.string :payment_type
      t.string :payment_status
      t.datetime :payment_date
      t.string :payment_id
      t.string :payment_from
      t.timestamps
    end
  end

  def self.down
    drop_table :orders
  end
end
