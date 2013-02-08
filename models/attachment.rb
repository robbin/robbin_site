class Attachment < ActiveRecord::Base
  mount_uploader :file, FileUploader
  validates_presence_of :file
    
  belongs_to :account
  belongs_to :blog
end
