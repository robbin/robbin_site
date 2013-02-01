class Attachment < ActiveRecord::Base
  mount_uploader :file, FileUploader
  
  belongs_to :account
  belongs_to :blog
  
end
