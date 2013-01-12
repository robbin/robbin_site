class BlogContent < ActiveRecord::Base
  acts_as_cached
  validates :content, :presence => true
end  
