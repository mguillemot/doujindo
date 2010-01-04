class AddNewsletterSubscriptionToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :newsletter, :boolean, :default => true, :null => false
  end

  def self.down
    raise 'Impossible to roll back this migration'
  end
end
