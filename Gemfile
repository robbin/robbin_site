source 'https://rubygems.org'

# Project requirements
gem 'rake'
gem 'tilt', '~> 1.3.7'
gem 'padrino-core', '~> 0.11'
gem 'padrino-helpers', '~> 0.11'

# Component requirements
gem 'bcrypt-ruby', :require => 'bcrypt'
gem 'erubis', '~> 2.7.0'
gem 'activerecord', '~> 3.2', :require => 'active_record'
gem 'mysql2'
gem 'dalli', :require => 'active_support/cache/dalli_store'
gem 'kgio'
gem "second_level_cache", :git => "git://github.com/csdn-dev/second_level_cache.git"
gem 'acts-as-taggable-on', :git => "git://github.com/robbin/acts-as-taggable-on.git"
gem 'github-markdown', :require => 'github/markdown'
gem 'will_paginate', :require => ['will_paginate/active_record', 'will_paginate/view_helpers/sinatra']
gem 'sanitize'
gem 'carrierwave', :require => ['carrierwave', 'carrierwave/orm/activerecord']
gem 'mini_magick'
gem 'rest-client'

# Production requirements
group :production do
  gem 'zbatery'
  # gem 'rainbows'
end

# Development requirements
group :development do
  gem 'pry-padrino'
  gem 'padrino-gen', '~> 0.11'
  gem 'thin'
end

# Test requirements
group :test do
  gem 'minitest', "~>2.6.0", :require => "minitest/autorun"
  gem 'rack-test', :require => "rack/test"
  gem 'factory_girl'
  gem 'database_cleaner'
end