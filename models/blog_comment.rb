class BlogComment < ActiveRecord::Base
  acts_as_cached
  
  validates_presence_of     :content
  
  belongs_to :blog, :counter_cache => :comments_count
  belongs_to :account, :counter_cache => :comments_count

  after_save :clean_cache
  before_destroy :clean_cache
  
  def clean_cache
    APP_CACHE.delete("#{CACHE_PREFIX}/layout/right")     # clean layout right column cache in _right.erb
  end
        
  def content_cache_key
    "#{CACHE_PREFIX}/comment_content/#{self.id}"
  end
  
  def brief_content
    Sanitize.clean(content).truncate(100)
  end
  
  def md_content
    APP_CACHE.fetch(content_cache_key) do
      Sanitize.clean(GitHub::Markdown.to_html(content, :gfm), Sanitize::Config::RELAXED)
    end
  end
end
