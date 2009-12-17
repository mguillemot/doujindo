class ItemStock < ActiveRecord::Migration
  def self.up
    remove_column :items, :publisher_en
    remove_column :items, :publisher_fr
    remove_column :items, :notes_en
    remove_column :items, :notes_fr
    remove_column :items, :format_en
    remove_column :items, :format_fr

    remove_column :items, :stock_left_new
    remove_column :items, :stock_left_perfect_condition
    remove_column :items, :stock_left_good_condition
    remove_column :items, :stock_left_medium_condition
    remove_column :items, :stock_left_poor_condition
    remove_column :items, :purchase_left
    remove_column :items, :reservation_left
    add_column :items, :stock, :integer, :null => false, :default => 0
    add_column :items, :stock_type, :string, :null => false, :default => 'new'
  end

  def self.down
    raise 'Impossible to roll back this migration'
  end
end
