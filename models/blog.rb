class Blog < ActiveRecord::Base
  acts_as_cached
  acts_as_taggable
  belongs_to :blog_content, :dependent => :destroy 
  validates :title, :presence => true
  validates :title, :length => {:in => 3..50}
  delegate :content, :to => :blog_content, :allow_nil => true
  
  def content=(value)
    self.blog_content ||= BlogContent.new
    self.blog_content.content = value
  end
end
