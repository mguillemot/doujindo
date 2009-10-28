class CreateCurrencies < ActiveRecord::Migration
  def self.up
    create_table :currencies do |t|
      t.string :description, :null => false
      t.string :symbol, :null => false
      t.decimal :rate_to_yen, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :currencies
  end
end
