class DropUserAddresses < ActiveRecord::Migration
  def self.up
    drop_table :user_addresses
  end

  def self.down
    raise 'Impossible to roll back this migration'
  end
end
