class CreateUserAddresses < ActiveRecord::Migration
  def self.up
    create_table :user_addresses do |t|
      t.integer :user_id, :null => false
      t.string :full_address, :null => false
      t.integer :country_id, :null => false
      t.string :phone_number
      t.string :additional_infos
      t.timestamps
    end
    add_index :user_addresses, :user_id
  end

  def self.down
    drop_table :user_addresses
  end
end
