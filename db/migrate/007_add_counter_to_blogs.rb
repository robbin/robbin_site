class AddCounterToBlogs < ActiveRecord::Migration
  def self.up
    add_column :blogs, :comments_count, :integer, :default => 0
    add_column :accounts, :blogs_count, :integer, :default => 0
  end

  def self.down
    remove_column :blogs, :comments_count
    remove_column :accounts, :blogs_count
  end
end
