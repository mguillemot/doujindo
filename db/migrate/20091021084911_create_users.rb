class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :login, :null => false
      t.string :password_hash, :null => false
      t.string :password_salt, :null => false
      t.string :first_name, :null => false
      t.string :last_name, :null => false
      t.string :email, :null => false
      t.string :email_confirmation_key
      t.datetime :email_confirmation_date
      t.boolean :admin, :null => false, :default => false
      t.integer :login_count, :null => false, :default => 0
      t.datetime :last_login
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
