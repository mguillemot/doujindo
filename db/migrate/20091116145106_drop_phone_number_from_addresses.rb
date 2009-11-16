class DropPhoneNumberFromAddresses < ActiveRecord::Migration
  def self.up
    remove_column :user_addresses, :phone_number
  end

  def self.down
    raise 'Impossible to roll back this migration'
  end
end
