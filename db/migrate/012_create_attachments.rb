class CreateAttachments < ActiveRecord::Migration
  def self.up
    create_table :attachments do |t|
      t.string :content_type
      t.string :filename
      t.integer :size
      t.integer :download_count, :null => false, :default => 0
      t.integer :account_id
      t.integer :blog_id
      t.timestamps
    end
    add_index :attachments, :account_id
    add_index :attachments, :blog_id
  end

  def self.down
    drop_table :attachments
  end
end
