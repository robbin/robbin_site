class AddCounterToBlogs < ActiveRecord::Migration
  def self.up
    add_column :blogs, :comments_count, :integer, :default => 0, :null => false
    add_column :accounts, :blogs_count, :integer, :default => 0, :null => false
  end

  def self.down
    remove_column :blogs, :comments_count
    remove_column :accounts, :blogs_count
  end
end
