class CreateCountries < ActiveRecord::Migration
  def self.up
    create_table :countries do |t|
      t.string :name_en, :null => false
      t.string :name_fr, :null => false
      t.string :ems_zone
      t.string :sal_zone
      t.string :geographic_zone, :null => false
      t.string :note
    end
  end

  def self.down
    drop_table :countries
  end
end
