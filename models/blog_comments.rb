class BlogComments < ActiveRecord::Base
  acts_as_cached
  belongs_to :blog
  belongs_to :account
end
