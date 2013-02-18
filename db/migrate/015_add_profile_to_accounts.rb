class AddProfileToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :profile_url, :string
    add_column :accounts, :profile_image_url, :string
  end

  def self.down
    remove_column :accounts, :profile_url
    remove_column :accounts, :profile_image_url
  end
end
