class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :login
      t.string :password_hash
      t.string :password_salt
      t.string :first_name
      t.string :last_name
      t.string :email
      t.integer :login_count, :null => false, :default => 0
      t.datetime :last_login
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
