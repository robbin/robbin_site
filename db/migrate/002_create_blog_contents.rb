class CreateBlogContents < ActiveRecord::Migration
  def self.up
    create_table :blog_contents do |t|
      # set limit 64k+1 to force column type longtext
      t.text :content, :null => false, :limit => 64.kilobytes + 1
    end
  end

  def self.down
    drop_table :blog_contents
  end
end
