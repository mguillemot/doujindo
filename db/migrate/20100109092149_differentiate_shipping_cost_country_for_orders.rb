class DifferentiateShippingCostCountryForOrders < ActiveRecord::Migration
  def self.up
    remove_column :orders, :ship_to_country_code
    add_column :orders, :shipping_calculated_for_country_id, :integer
  end

  def self.down
    raise 'Impossible to roll back this migration'
  end
end
