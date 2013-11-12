# Defines our constants
PADRINO_ENV  = ENV['PADRINO_ENV'] ||= ENV['RACK_ENV'] ||= 'development'  unless defined?(PADRINO_ENV)
PADRINO_ROOT = File.expand_path('../..', __FILE__) unless defined?(PADRINO_ROOT)

# Load our dependencies
require 'rubygems' unless defined?(Gem)
require 'bundler/setup'
Bundler.require(:default, PADRINO_ENV)

##
# ## Enable devel logging
#
# Padrino::Logger::Config[:development][:log_level]  = :devel
# Padrino::Logger::Config[:development][:log_static] = true
#
# ## Configure your I18n
#
I18n.default_locale = 'zh_cn'

Dir.glob(File.expand_path("#{PADRINO_ROOT}/locale", __FILE__) + '/**/*.yml').each do |file|
  I18n.load_path << file
end

# ## Configure your HTML5 data helpers
#
# Padrino::Helpers::TagHelpers::DATA_ATTRIBUTES.push(:dialog)
# text_field :foo, :dialog => true
# Generates: <input type="text" data-dialog="true" name="foo" />
#
# ## Add helpers to mailer
#
# Mail::Message.class_eval do
#   include Padrino::Helpers::NumberHelpers
#   include Padrino::Helpers::TranslationHelpers
# end

##
# Add your before (RE)load hooks here
#
Padrino.before_load do
end

##
# Add your after (RE)load hooks here
#
Padrino.after_load do
end

# load project config
APP_CONFIG = YAML.load_file(File.expand_path("#{PADRINO_ROOT}/config", __FILE__) + '/app_config.yml')[PADRINO_ENV]

# initialize memcache and ActiveRecord Cache
Dalli.logger = logger
APP_CACHE = ActiveSupport::Cache::DalliStore.new("127.0.0.1")
CACHE_PREFIX = "robbin"
SecondLevelCache.configure do |config|
  config.cache_store = APP_CACHE
  config.logger = logger
  config.cache_key_prefix = CACHE_PREFIX
end
  
# Set acts_as_taggable
ActsAsTaggableOn.remove_unused_tags = true
ActsAsTaggableOn.strict_case_match = true

# Set will_paginate default page number
WillPaginate.per_page = 15

# Set carrierwave sanitize
CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:]\.\-\+]/

Padrino.load!