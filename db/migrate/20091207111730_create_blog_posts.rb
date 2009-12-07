class CreateBlogPosts < ActiveRecord::Migration
  def self.up
    create_table :blog_posts do |t|
      t.string :ident, :null => false
      t.integer :author_id, :null => false
      t.string :title_en
      t.string :title_fr
      t.text :content_en
      t.text :content_fr
      t.timestamps
    end
    add_index :blog_posts, :ident, :unique => true
  end

  def self.down
    drop_table :blog_posts
  end
end
