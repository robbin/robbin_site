class CreateBlogs < ActiveRecord::Migration
  def self.up
    create_table :blogs do |t|
      t.string :title, :limit => 255, :null => false
      t.string :slug_url, :limit => 255
      t.integer :view_count, :default => 0, :null => false
      t.references :blog_content, :null => false
      t.timestamps
    end
    add_index :blogs, :blog_content_id
  end

  def self.down
    drop_table :blogs
  end
end
