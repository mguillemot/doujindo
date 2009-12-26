class CreateNews < ActiveRecord::Migration
  def self.up
    create_table :news do |t|
      t.text :content_en
      t.text :content_fr
      t.timestamps
    end
    add_index :news, :created_at
  end

  def self.down
    drop_table :news
    remove_index :news, :created_at
  end
end
