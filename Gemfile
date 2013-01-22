source :rubygems

# Project requirements
gem 'rake'
gem 'padrino-core', :git => 'git://github.com/padrino/padrino-framework.git'
gem 'padrino-helpers', :git => 'git://github.com/padrino/padrino-framework.git'

# Component requirements
gem 'bcrypt-ruby', :require => 'bcrypt'
gem 'erubis', '~> 2.7.0'
gem 'activerecord', :require => 'active_record'
gem 'mysql2'
gem 'dalli'
gem 'kgio'
gem "second_level_cache", :git => "git://github.com/csdn-dev/second_level_cache.git"
gem 'acts-as-taggable-on', :git => "git://github.com/robbin/acts-as-taggable-on.git"
gem 'github-markdown', :require => 'github/markdown'
gem 'will_paginate', :require => ['will_paginate/active_record']

# Development requirements
group :development do
  gem 'thin'
  gem 'pry'
  gem 'padrino-gen', :git => 'git://github.com/padrino/padrino-framework.git'
end

# Test requirements
group :test do
  gem 'minitest', "~>2.6.0", :require => "minitest/autorun"
  gem 'rack-test', :require => "rack/test"
  gem 'factory_girl'
  gem 'database_cleaner'
end