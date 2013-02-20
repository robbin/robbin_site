class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  storage :file
  
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url
   "/images/default_logo.jpg"
  end
  
  version :normal do
    process :resize_to_fill => [80, 80]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
