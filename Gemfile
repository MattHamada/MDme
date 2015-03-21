source 'https://rubygems.org'
ruby '2.2.0'
#ruby-gemset=mdme-rails4.2


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'

#gem 'activejob_time_serialize', '0.1.1'

#gem 'bootstrap-sass', '3.3.1'
gem 'font-awesome-rails'
gem 'autoprefixer-rails'


#gem 'anjlab-bootstrap-rails', :require => 'bootstrap-rails',
#                              :github => 'anjlab/bootstrap-rails',
#                              :branch => '3.0.0'

#for encrypting cookies
gem 'bcrypt-ruby', '3.1.2'

#text populator
gem 'faker', '1.1.2'

#generating patient ids
gem 'uuid'

#push notifications
gem 'pushmeup'

#rabl json markup
gem 'rabl'
gem 'oj'

#pdf generation
gem 'prawn'

#helper for page breadcrumbs
gem "breadcrumbs_on_rails"

#generate qr code images
gem 'rqrcode-rails3'
gem 'mini_magick'

#help in calling 3rd party apis
gem 'httparty'

#encrypt database fields
gem 'attr_encrypted'

#adds respond_to calls
gem 'responders'

gem 'rdoc'

#front end js package manager
gem 'bower-rails'
#precaches angular views
gem 'angular-rails-templates'

group :development do
  #nicer error page
  gem 'better_errors'
  gem 'binding_of_caller'
  #monitors for database optimizations in development
  gem 'bullet'
  #for viewing emails sent
  gem 'letter_opener'
  #security auditing
  gem 'brakeman', require: false
end

group :development, :test do
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3', '1.3.9'
  #gem 'rspec-rails', '2.14.2'
  gem 'rspec-rails'
  # gem 'guard-rspec' #rspec generation and autotest
  #gem 'guard-livereload'
  #gem 'ruby-debug19'  #allow ruby debugger
  #gem 'json_spec', '~> 1.1.1'
end

group :test do
  gem 'selenium-webdriver', '2.35.1'
  #gem 'rspec-its'
  #gem 'ZenTest'
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'factory_girl_rails', '4.2.0'
  # gem 'cucumber-rails', '1.4.0', :require => false
  # gem 'cucumber-rails-training-wheels' #premade stepdefs
  gem 'database_cleaner', github: 'bmabey/database_cleaner' #reset cucumber db after test
  gem 'libnotify', '0.8.0'
  # gem 'launchy' #debug tool for user stories
  gem 'simplecov', :require => false
  gem 'timecop'
  gem 'capybara-slow_finder_errors'
end

group :production, :staging do
  gem 'pg', '0.15.1'
  gem 'unicorn'
end

group :production do
  gem 'rails_12factor', '0.0.2' #heroku logging
end

#haml markup templates
gem 'haml'
# Use SCSS for stylesheets
# gem 'sass-rails', '~> 4.0.0'
gem 'sass', '3.2.19'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '2.1.1'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails', '3.0.4'
gem 'jquery-ui-rails', '5.0.3'
gem 'jquery-turbolinks'


# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '2.3.0'


# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '1.0.2'

#for file uploads
gem 'paperclip', '~> 4.1'


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
