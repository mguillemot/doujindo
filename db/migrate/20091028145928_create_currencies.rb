class CreateCurrencies < ActiveRecord::Migration
  def self.up
    create_table :currencies do |t|
      t.string :description_en
      t.string :description_fr
      t.string :symbol, :null => false
      t.string :format_en
      t.string :format_fr
      t.decimal :rate_to_yen, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :currencies
  end
end
