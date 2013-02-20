class AddLogoToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :logo, :string
    add_column :blogs, :category, :string, :limit => 20
    Blog.transaction do
      Blog.all.each do |blog|
        blog.category = 'blog' if blog.tag_list.include?('blog')
        blog.category = 'note' if blog.tag_list.include?('note')
        blog.tag_list = blog.tag_list - ['note', 'blog']
        blog.save!
      end
    end
  end

  def self.down
    remove_column :accounts, :logo
    remove_column :blogs, :category
  end
end
