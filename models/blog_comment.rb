class BlogComment < ActiveRecord::Base
  acts_as_cached
  belongs_to :blog, :counter_cache => :comments_count
  belongs_to :account
end
