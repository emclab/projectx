source "http://rubygems.org"

# Declare your gem's dependencies in projectx.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# jquery-rails is used by the dummy application
gem "jquery-rails"
gem 'will_paginate'

#gem 'authentify', :path => '../authentify'  #for rspec test
#gem 'customerx', :path => '../customerx'
gem 'authentify', :git => 'http://github.com/emclab/authentify.git'
gem 'customerx', :git => 'http://github.com/emclab/customerx'

group :test do
  gem "rspec-rails", ">= 2.0.0"
  gem "factory_girl_rails" #, '~>3.0'
  gem 'faker'
  gem 'capybara'
  gem 'guard-rspec'
  gem 'launchy'
end


# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use debugger
# gem 'debugger'
