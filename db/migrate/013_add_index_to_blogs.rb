class AddIndexToBlogs < ActiveRecord::Migration
  def self.up
    add_index :blogs, :content_updated_at
    remove_index :blogs, :blog_content_id
  end

  def self.down
    remove_index :blogs, :content_updated_at
    add_index :blogs, :blog_content_id
  end
end
