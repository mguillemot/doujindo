class CreateOsusumes < ActiveRecord::Migration
  def self.up
    create_table :osusumes do |t|
      t.integer :item_id, :null => false
      t.string :from, :null => false
      t.string :reason_en
      t.string :reason_fr
      t.timestamps
    end
  end

  def self.down
    drop_table :osusumes
  end
end
