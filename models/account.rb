require 'openssl'
require 'base64'

class Account < ActiveRecord::Base
  attr_accessor :password, :password_confirmation
  acts_as_cached
  mount_uploader :logo, AvatarUploader
  has_many :blogs
  has_many :blog_comments, :dependent => :destroy
  has_many :attachments
  
  # Validations
  validates_presence_of     :email,                      :if => :native_login_required
  validates_presence_of     :password,                   :if => :native_login_required
  validates_presence_of     :password_confirmation,      :if => :native_login_required
  validates_length_of       :password, :within => 4..40, :if => :native_login_required
  validates_confirmation_of :password,                   :if => :native_login_required
  validates_length_of       :email,    :within => 3..100, :if => :native_login_required
  validates_uniqueness_of   :email,    :case_sensitive => false, :if => :native_login_required
  validates_format_of       :email,    :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :if => :native_login_required
  validates_format_of       :role,     :with => /[A-Za-z]/

  # Callbacks
  before_save :encrypt_password, :if => :password_required

  ##
  # This method is for authentication purpose
  #
  def self.authenticate(email, password)
    account = first(:conditions => { :email => email }) if email.present?
    account && account.has_password?(password) ? account : nil
  end

  def has_password?(password)
    ::BCrypt::Password.new(crypted_password) == password
  end

  def admin?
    self.role == 'admin'
  end
  
  def commenter?
    self.role == 'commenter'
  end
  
  def encrypt_cookie_value
    cipher = OpenSSL::Cipher::AES.new(256, :CBC)
    cipher.encrypt
    cipher.key = APP_CONFIG['session_secret']
    Base64.encode64(cipher.update("#{id} #{crypted_password}") + cipher.final)
  end
  
  def self.decrypt_cookie_value(encrypted_value)
    decipher = OpenSSL::Cipher::AES.new(256, :CBC)
    decipher.decrypt
    decipher.key = APP_CONFIG['session_secret']
    plain = decipher.update(Base64.decode64(encrypted_value)) + decipher.final
    id, crypted_password = plain.split
    return id.to_i, crypted_password
  rescue
    return 0, ""
  end

  def self.validate_cookie(encrypted_value)
    user_id, crypted_password = decrypt_cookie_value(encrypted_value)
    if (account = Account.find_by_id(user_id)) && (account.crypted_password = crypted_password)
      return account
    end
  end
  
  private
  def encrypt_password
    self.crypted_password = ::BCrypt::Password.create(password) unless password.blank?
  end

  def password_required
    crypted_password.blank? || password.present?
  end
  
  def native_login_required
    provider.blank? && password_required
  end
end
