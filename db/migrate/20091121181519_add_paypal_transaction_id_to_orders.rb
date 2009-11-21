class AddPaypalTransactionIdToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :paypal_transaction_id, :string
  end

  def self.down
    raise 'Impossible to roll back this migration'
  end
end
