source 'https://rubygems.org'
ruby '2.3.0'
#ruby-gemset=mdme


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
# gem 'rails', '4.2.5'
gem 'rails', '5.0.0.beta4'

gem 'multi_json'

#gem 'activejob_time_serialize', '0.1.1'

# gem 'bootstrap-sass', '3.3.1'
gem 'font-awesome-rails'
gem 'autoprefixer-rails'


#gem 'anjlab-bootstrap-rails', :require => 'bootstrap-rails',
#                              :github => 'anjlab/bootstrap-rails',
#                              :branch => '3.0.0'

#for encrypting cookies
gem 'bcrypt-ruby'

#text populator
gem 'faker', '1.1.2'

#generating patient idsd

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
# gem 'rqrcode-rails3'
gem 'rqrcode'
gem 'mini_magick'

#help in calling 3rd party apis
gem 'httparty'
gem 'rdoc'


#encrypt database fields
gem 'attr_encrypted'

#adds respond_to calls
gem 'responders'

gem 'tzinfo'
gem 'tzinfo-data'

#front end js package manager
# gem 'bower-rails'
#precaches angular views
# gem 'angular-rails-templates'

#json web token lib
gem 'jwt'

#pg for all env
gem 'pg', '0.18.4'

gem "gmap_coordinates_picker"


#bower assets in gem form
source 'https://rails-assets.org' do
  gem 'rails-assets-tether'
  gem 'rails-assets-bootstrap', '4.0.0.alpha.2'
  # gem 'rails-assets-angular', '1.4.3'
  # gem 'rails-assets-angular-route' , '1.4.3'
  # gem 'rails-assets-angular-resource', '1.4.3'
  # gem 'rails-assets-angular-ui-router', '0.2.9'
  # gem 'rails-assets-angular-local-storage', '0.2.2'
  # gem 'rails-assets-angular-mocks', '1.4.3'
  # gem 'rails-assets-angular-jwt', '0.0.9'
  # gem 'rails-assets-ng-file-upload', '6.0.4'
  # gem 'rails-assets-angular-flare'
  # gem 'rails-assets-angular-ui-utils', '3.0.0'
  # gem 'rails-assets-angular-google-maps', '2.1.5'
  # gem 'rails-assets-angular-ui-validate', '1.1.1'
end

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
  #performance benchmarking
  gem 'rack-mini-profiler', require: false
end

group :development, :test do
  # Use sqlite3 as the database for Active Record
  # gem 'sqlite3', '1.3.9'
  #gem 'rspec-rails', '2.14.2'
  gem 'rspec', github: 'rspec/rspec'
  gem 'rspec-mocks', github: 'rspec/rspec-mocks'
  gem 'rspec-expectations', github: 'rspec/rspec-expectations'
  gem 'rspec-support', github: 'rspec/rspec-support'
  gem 'rspec-core', github: 'rspec/rspec-core'  
  gem 'rspec-rails', :github=>'rspec/rspec-rails'
  gem 'phantomjs'
  # gem 'guard-rspec' #rspec generation and autotest
  #gem 'guard-livereload'
  #gem 'ruby-debug19'  #allow ruby debugger
  #gem 'json_spec', '~> 1.1.1'
end

group :test do
  gem 'selenium-webdriver', '2.45'
  #gem 'rspec-its'
  #gem 'ZenTest'
  gem 'capybara'
  gem 'capybara-webkit'
  # gem 'capybara-angular'
  gem 'factory_girl_rails', '4.2.0'
  # gem 'cucumber-rails', '1.4.0', :require => false
  # gem 'cucumber-rails-training-wheels' #premade stepdefs
  gem 'database_cleaner', github: 'bmabey/database_cleaner' #reset cucumber db after test
  gem 'libnotify', '0.8.0'
  # gem 'launchy' #debug tool for user stories
  gem 'simplecov', :require => false
  gem 'timecop'
  # gem 'capybara-slow_finder_errors'
  gem 'poltergeist'
  # gem 'capybara-angular', github: 'wrozka/capybara-angular'
  gem 'capybara-screenshot'
end

group :production, :staging do
  # gem 'unicorn'
  gem 'puma'
end

group :production do
  gem 'rails_12factor', '0.0.2' #heroku logging
  gem "rails_serve_static_assets"
end

#haml markup templates
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0.4'
gem 'sass', '3.4.18'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '2.7.2'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails', '4.0.5'
gem 'jquery-ui-rails'
# gem 'jquery-turbolinks', 


# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks' , '~> 5.0.0.beta'


# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '1.0.2'

#for file uploads
gem 'paperclip', '4.2.2'

gem 'state_machines'
gem 'state_machines-activemodel', github: 'ermacaz/state_machines-activemodel'
gem 'state_machines-activerecord', github: 'ermacaz/state_machines-activerecord'


group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', '0.3.20', require: false
end


# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
