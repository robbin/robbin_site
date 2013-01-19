class AddModifedAtToBlogs < ActiveRecord::Migration
  def self.up
    add_column :blogs, :modified_at, :datetime
    Blog.all.each {|blog| blog.modified_at = Time.now; blog.save!}
  end

  def self.down
    remove_column :blogs, :modified_at
  end
end
