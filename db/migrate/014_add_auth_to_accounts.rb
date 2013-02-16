class AddAuthToAccounts < ActiveRecord::Migration
  def self.up
    remove_index :accounts, :email
    add_column :accounts, :uid, :string
    add_column :accounts, :provider, :string, :limit => 20
    add_column :accounts, :comments_count, :integer, :default => 0, :null => false
    remove_column :blogs, :original
    remove_column :blogs, :original_url
  end

  def self.down
    remove_column :accounts, :uid
    remove_column :accounts, :provider
    remove_column :accounts, :comments_count
    add_column :blogs, :original, :boolean
    add_column :blogs, :original_url, :string
  end
end
