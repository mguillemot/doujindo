class RemovePaymentFromFromOrders < ActiveRecord::Migration
  def self.up
    remove_columns :orders, :payment_from
  end

  def self.down
    raise 'Impossible to roll back this migration'
  end
end
