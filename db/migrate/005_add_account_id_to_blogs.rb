class AddAccountIdToBlogs < ActiveRecord::Migration
  def change
    add_column :blogs, :account_id, :integer
    add_index :blogs, :account_id
  end
end
