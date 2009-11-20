class AddPaypalInfosToOrders < ActiveRecord::Migration
  def self.up
    remove_columns :orders, :shipping_address_id, :payment_number
    add_column :orders, :ship_to_name, :string
    add_column :orders, :ship_to_street, :string
    add_column :orders, :ship_to_zip, :string
    add_column :orders, :ship_to_city, :string
    add_column :orders, :ship_to_state, :string
    add_column :orders, :ship_to_country_id, :integer
    add_column :orders, :paypal_token, :string
    add_column :orders, :paypal_payer_id, :string
  end

  def self.down
    raise 'Impossible to roll back this migration'
  end
end
