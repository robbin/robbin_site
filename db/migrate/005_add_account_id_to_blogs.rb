class AddAccountIdToBlogs < ActiveRecord::Migration
  def self.up
    add_column :blogs, :account_id, :integer
    add_index :blogs, :account_id
    Blog.all.each do |blog| 
      if blog.account.blank?
        blog.account_id = 1; blog.save!
      end
    end
  end
  
  def self.down
    remove_column :blogs, :account_id
  end
end
