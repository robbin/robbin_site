class CreateBlogComments < ActiveRecord::Migration
  def self.up
    create_table :blog_comments do |t|
      t.references :account
      t.references :blog
      t.text :content
      t.datetime :created_at
    end
    add_index :blog_comments, :account_id
    add_index :blog_comments, :blog_id
  end

  def self.down
    drop_table :blog_comments
  end
end
