class Blog < ActiveRecord::Base
  acts_as_cached
  acts_as_taggable
  
  belongs_to :blog_content, :dependent => :destroy 
  belongs_to :account, :counter_cache => true
  has_many :comments, :class_name => 'BlogComment', :dependent => :destroy
  
  validates :title, :presence => true
  validates :title, :length => {:in => 3..50}
  
  delegate :content, :to => :blog_content, :allow_nil => true
  
  def content=(value)
    self.blog_content ||= BlogContent.new
    self.blog_content.content = value
  end

  def update_blog(param_hash)
    self.transaction do
      self.update_attributes!(param_hash)
      self.content_updated_at = Time.now
      self.blog_content.save!
      self.save!
    end
  rescue
    return false
  end
  
  def content_cache_key
    "#{CACHE_PREFIX}/#{self.class.to_s}/#{self.content_updated_at.to_i}"
  end
  
  def md_content(mode = :gfm)
    APP_CACHE.fetch(self.content_cache_key, :expires_in => 14.days) do
      GitHub::Markdown.to_html(self.content, mode)
    end
  end
end
