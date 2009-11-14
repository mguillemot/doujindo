class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.integer :client_id, :null => false
      t.integer :shipping_address_id
      t.integer :currency_id, :null => false
      t.decimal :items_total_price, :null => false, :precision => 8, :scale => 2
      t.text :notes
      t.string :shipping_type
      t.decimal :shipping_price, :precision => 8, :scale => 2
      t.string :shipping_status
      t.datetime :shipping_sent_date
      t.string :shipping_tracking_number
      t.string :payment_type
      t.string :payment_status
      t.datetime :payment_date
      t.string :payment_number
      t.string :payment_from
      t.timestamps
    end
    add_index :orders, :client_id
  end

  def self.down
    drop_table :orders
  end
end
