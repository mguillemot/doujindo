class AddPaypalCountryCodeToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :ship_to_country_code, :string
  end

  def self.down
    raise 'Impossible to roll back this migration'
  end
end
