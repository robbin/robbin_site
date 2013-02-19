class Blog < ActiveRecord::Base
  acts_as_cached
  acts_as_taggable

  attr_protected :account_id, :blog_content_id
  
  after_save :clean_cache
  before_destroy :clean_cache
  
  belongs_to :blog_content, :dependent => :destroy 
  belongs_to :account, :counter_cache => true
  has_many :comments, :class_name => 'BlogComment', :dependent => :destroy
  has_many :attachments, :dependent => :destroy
  
  validates :title, :presence => true
  validates :title, :length => {:in => 3..50}
  
  delegate :content, :to => :blog_content, :allow_nil => true

  # virtual property for article category: blog, note
  def category
    return 'blog' if tag_list.include?('blog')
    return 'note' if tag_list.include?('note')
  end
  
  def category=(category_name)
    if category_name && ['blog', 'note'].include?(category_name)
      self.tag_list << category_name unless self.tag_list.include?(category_name)
    end
  end
  
  # virtual property for setting tag_list
  def user_tags
    (self.tag_list - ['blog', 'note']).join(" , ")
  end
  
  def user_tags=(tags)
    unless tags.blank?
      # filter illegal characters
      user_tags_list = (tags.split(",").collect{|t| t.strip.downcase}.uniq.select{|t| t =~ /^(?!_)(?!.*?_$)[a-zA-Z0-9_\s\u4e00-\u9fa5]+$/} - ['blog', 'note']).join(",") 
      user_tags_list.prepend("#{category},") if category
      self.tag_list = user_tags_list
    end  
  end
  
  # virtual property for blog_content's content body
  def content=(value)            # must prepend self otherwise do not update blog_content
    self.blog_content ||= BlogContent.new
    self.blog_content.content = value
    self.content_updated_at = Time.now
  end

  def update_blog(param_hash)
    self.transaction do
      update_attributes!(param_hash)
      blog_content.save!
      save!
    end
  rescue
    return false
  end
  
  def attach!(owner)
    self.transaction do
      owner.attachments.orphan.each {|attachment| attachment.update_attribute(:blog_id, self.id) }
    end
  end
  
  # blog viewer hit counter
  def increment_view_count
    increment(:view_count)        # add view_count += 1
    write_second_level_cache      # update cache per hit, but do not touch db
                                  # update db per 10 hits
    self.class.update_all({:view_count => view_count}, :id => id) if view_count % 10 == 0
  end
  
  def cached_tags
    cached_tag_list ? cached_tag_list.split(",").collect{|t| t.strip}.reject{|t| ['blog', 'note'].include?(t)} : []
  end
  
  def clean_cache
    APP_CACHE.delete("#{CACHE_PREFIX}/blog_tags/tag_cloud")   # clean tag_cloud
    APP_CACHE.delete("#{CACHE_PREFIX}/rss/all")               # clean rss cache
    APP_CACHE.delete("#{CACHE_PREFIX}/layout/right")          # clean layout right column cache in _right.erb
  end
  
  def content_cache_key
    "#{CACHE_PREFIX}/blog_content/#{self.id}/#{content_updated_at.to_i}"
  end
  
  def md_content(mode = :gfm)  # cached markdown format blog content
    APP_CACHE.fetch(content_cache_key) { GitHub::Markdown.to_html(content, mode) }
  end
  
  def self.cached_tag_cloud
    APP_CACHE.fetch("#{CACHE_PREFIX}/blog_tags/tag_cloud") do
      self.tag_counts.sort_by(&:count).reverse.reject {|t| t.name == 'blog' || t.name == 'note'}
    end
  end
  
  def self.hot_blogs(count)
    self.order('comments_count DESC, view_count DESC').limit(count)
  end
end
