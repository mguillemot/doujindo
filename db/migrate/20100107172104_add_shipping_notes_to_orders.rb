class AddShippingNotesToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :shipping_notes, :string
  end

  def self.down
    raise 'Impossible to roll back this migration'
  end
end
