class AddColumnsToBlogs < ActiveRecord::Migration
  def self.up
    rename_column :blogs, :modified_at, :content_updated_at
    add_column :blogs, :commentable, :boolean, :default => true, :null => false
    add_column :blogs, :original, :boolean, :default => true, :null => false
    add_column :blogs, :original_url, :string, :limit => 255
  end

  def self.down
    rename_column :blogs, :content_updated_at, :modified_at
    remove_column :blogs, :commentable
    remove_column :blogs, :original
    remove_column :blogs, :original_url
  end
end
