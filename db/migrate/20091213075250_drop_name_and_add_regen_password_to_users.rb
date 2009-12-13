class DropNameAndAddRegenPasswordToUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :first_name
    remove_column :users, :last_name
    add_column :users, :lost_password_key, :string
    add_column :users, :lost_password_date, :datetime
  end

  def self.down
    raise 'Impossible to roll back this migration'
  end
end
