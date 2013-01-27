class Blog < ActiveRecord::Base
  acts_as_cached
  acts_as_taggable

  attr_protected :account_id, :blog_content_id
  
  after_save :clear_cache
  before_destroy :clear_cache
  
  belongs_to :blog_content, :dependent => :destroy 
  belongs_to :account, :counter_cache => true
  has_many :comments, :class_name => 'BlogComment', :dependent => :destroy
  
  validates :title, :presence => true
  validates :title, :length => {:in => 3..50}
  
  delegate :content, :to => :blog_content, :allow_nil => true
  
  scope :by_join_date, order('created_at DESC')
  
  def content=(value)            # must prepend self otherwise do not update blog_content
    self.blog_content ||= BlogContent.new
    self.blog_content.content = value
    self.content_updated_at = Time.now
  end

  def update_blog(param_hash)
    transaction do
      update_attributes!(param_hash)
      blog_content.save!
      save!
    end
  rescue
    return false
  end
  
  # blog viewer hit counter
  def increment_view_count
    increment(:view_count)        # add view_count += 1
    write_second_level_cache      # update cache per hit, but do not touch db
                                  # update db per 10 hits
    self.class.update_all({:view_count => view_count}, :id => id) if view_count % 10 == 0
  end
  
  def cached_tags
    cached_tag_list ? cached_tag_list.split(",").collect {|t| t.strip} : []
  end
  
  def clear_cache
    APP_CACHE.delete("#{CACHE_PREFIX}/blog_tags/hot")    # clear hot_tags
    APP_CACHE.delete("#{CACHE_PREFIX}/hot_blogs")        # clear hot_blogs
  end
  
  def content_cache_key
    "#{CACHE_PREFIX}/blog_content/#{self.id}/#{content_updated_at.to_i}"
  end
  
  def md_content(mode = :gfm)
    APP_CACHE.fetch(content_cache_key) do
      GitHub::Markdown.to_html(content, mode)
    end
  end
  
  def self.hot_tags
    APP_CACHE.fetch("#{CACHE_PREFIX}/blog_tags/hot") do
      self.tag_counts.sort_by(&:count).reverse.select {|t| t.count > 1}
    end
  end
  
  def self.hot_blogs
    APP_CACHE.fetch("#{CACHE_PREFIX}/hot_blogs", :expire_in => 1.day) do
      self.order('view_count DESC, comments_count DESC').limit(5).all
    end
  end
end
