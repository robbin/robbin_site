class RemoveCategoryFromBlogs < ActiveRecord::Migration
  def self.up
    remove_column :blogs, :category
  end

  def self.down
    add_column :blogs, :category, :string, :limit => 20, :default => "blog"
  end
end
