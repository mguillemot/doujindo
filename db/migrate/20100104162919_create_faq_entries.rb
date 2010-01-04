class CreateFaqEntries < ActiveRecord::Migration
  def self.up
    create_table :faq_entries do |t|
      t.boolean :category, :null => false, :default => false
      t.string :toc_entry_en, :null => false
      t.string :toc_entry_fr, :null => false
      t.string :question_en
      t.string :question_fr
      t.string :answer_avatar
      t.text :answer_en
      t.text :answer_fr
      t.integer :parent_id
      t.float :display_order, :null => false
      t.timestamps
    end
    add_index :faq_entries, :display_order
    add_index :faq_entries, :parent_id
    add_index :faq_entries, :category
  end

  def self.down
    drop_table :faq_entries
  end
end
