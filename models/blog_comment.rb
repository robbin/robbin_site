class BlogComment < ActiveRecord::Base
  acts_as_cached
  belongs_to :blog, :counter_cache => :comments_count
  belongs_to :account

  after_save :clean_cache
  before_destroy :clean_cache
  
  def clean_cache
    APP_CACHE.delete("#{CACHE_PREFIX}/layout/right")     # clear layout right column cache in _right.erb
  end
        
  def content_cache_key
    "#{CACHE_PREFIX}/comment_content/#{self.id}"
  end
  
  def brief_content
    Sanitize.clean(content)
  end
  
  def md_content(mode = :gfm)
    APP_CACHE.fetch(content_cache_key) do
      Sanitize.clean(GitHub::Markdown.to_html(content, mode), Sanitize::Config::BASIC)
    end
  end
end
