class AddCachedTagListToBlogs < ActiveRecord::Migration
  def self.up
    add_column :blogs, :cached_tag_list, :string
  end

  def self.down
    remove_column :blogs, :cached_tag_list
  end
end
