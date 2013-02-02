class CreateAttachments < ActiveRecord::Migration
  def self.up
    create_table :attachments do |t|
      t.string :file
      t.integer :account_id
      t.integer :blog_id
      t.datetime :created_at
    end
    add_index :attachments, :account_id
    add_index :attachments, :blog_id
  end

  def self.down
    drop_table :attachments
  end
end
