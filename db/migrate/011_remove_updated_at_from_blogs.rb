class RemoveUpdatedAtFromBlogs < ActiveRecord::Migration
  def self.up
    remove_column :blogs, :updated_at
  end

  def self.down
    add_column :blogs, :updated_at, :datetime
  end
end
