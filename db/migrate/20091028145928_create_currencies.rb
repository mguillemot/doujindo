class CreateCurrencies < ActiveRecord::Migration
  def self.up
    create_table :currencies do |t|
      t.string :description_en, :null => false
      t.string :description_fr, :null => false
      t.string :symbol, :null => false
      t.string :format_en, :null => false
      t.string :format_fr, :null => false
      t.decimal :rate_to_yen, :null => false, :precision => 8, :scale => 2
      t.timestamps
    end
  end

  def self.down
    drop_table :currencies
  end
end
