class AddAuthToAccounts < ActiveRecord::Migration
  def self.up
    remove_index :accounts, :email
    add_column :accounts, :uid, :string
    add_column :accounts, :provider, :string, :limit => 20
    add_column :accounts, :comments_count, :integer, :default => 0, :null => false
  end

  def self.down
    remove_column :accounts, :uid
    remove_column :accounts, :provider
    remove_column :accounts, :comments_count
  end
end
