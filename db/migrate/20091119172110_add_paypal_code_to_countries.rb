class AddPaypalCodeToCountries < ActiveRecord::Migration
  def self.up
    add_column :countries, :paypal_code, :string
  end

  def self.down
    raise 'Impossible to roll back this migration'
  end
end
