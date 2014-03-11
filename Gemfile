source 'https://rubygems.org'
ruby '2.1.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.3'

gem 'bootstrap-sass', '3.0.3.0'
gem 'font-awesome-rails'

#gem 'anjlab-bootstrap-rails', :require => 'bootstrap-rails',
#                              :github => 'anjlab/bootstrap-rails',
#
#                              :branch => '3.0.0'
gem 'bcrypt-ruby', '3.1.2'
gem 'faker', '1.1.2'
gem 'will_paginate', '3.0.4'
gem 'bootstrap-will_paginate', '0.0.9'
gem "rocket_pants", "~> 1.9.1" #api

group :development do
  #nicer error page
  gem 'better_errors'
  gem 'binding_of_caller'
  #monitors for database optimizations in development
  gem 'bullet'
  #for viewing emails sent
  gem 'letter_opener'
end

group :development, :test do
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3', '1.3.9'
  gem 'rspec-rails'
  gem 'guard-rspec', '2.5.0' #rspec generation and autotest
  #gem 'ruby-debug19'  #allow ruby debugger
end

group :test do
  gem 'selenium-webdriver', '2.35.1'
  #gem 'ZenTest'
  gem 'capybara', '2.2.1'
  gem 'capybara-webkit'
  gem 'factory_girl_rails', '4.2.0'
  gem 'cucumber-rails', '1.4.0', :require => false
  gem 'cucumber-rails-training-wheels' #premade stepdefs
  gem 'database_cleaner', github: 'bmabey/database_cleaner' #reset cucumber db after test
  gem 'libnotify', '0.8.0'
  gem 'launchy' #debug tool for user stories
  gem 'simplecov', :require => false
end

group :production do
  gem 'pg', '0.15.1'
  gem 'rails_12factor', '0.0.2'
end

#haml markup templates
gem 'haml'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '2.1.1'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails', '3.0.4'
gem 'jquery-ui-rails'
gem 'jquery-turbolinks'


# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '1.1.1'


# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '1.0.2'

#for file uploads
gem "paperclip", "~> 3.5.2"


group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', '0.3.20', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
