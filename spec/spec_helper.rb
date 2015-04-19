require 'simplecov'
SimpleCov.start

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
#require 'rspec/autorun'
require 'subdomains'
#require 'factory_girl_rails'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
#ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)
ActiveRecord::Migration.maintain_test_schema! #for rails 4.1+

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"


  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'

  config.include Capybara::DSL
  # Capybara.javascript_driver = :webkit
  Capybara.javascript_driver = :selenium

  #add helpers from app
  config.include ApplicationHelper

  #from rspec2 deprication message
  config.infer_spec_type_from_file_location!


  #below needed for db transactions to stick with capybara :webkit testing
  #found http://stackoverflow.com/questions/8178120/capybara-with-js-true-causes-test-to-fail
  config.use_transactional_fixtures = false

  # config.before :each do
  #   if Capybara.current_driver == :rack_test
  #     DatabaseCleaner.strategy = :transaction
  #   else
  #     DatabaseCleaner.strategy = :truncation
  #   end
  #   DatabaseCleaner.start
  # end
  #
  #
  # config.after do
  #   DatabaseCleaner.clean
  # end
  #
  # config.before(:suite) do
  #   DatabaseCleaner.clean_with :truncation
  #   DatabaseCleaner.clean_with :transaction
  # end
  #
  # config.around(:each, type: :feature, js: true) do |ex|
  #   DatabaseCleaner.strategy = :truncation
  #   DatabaseCleaner.start
  #   self.use_transactional_fixtures = false
  #   ex.run
  #   self.use_transactional_fixtures = true
  #   DatabaseCleaner.clean
  # end

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  #include email helpers
  config.include(MailerMacros)
  config.before(:each) { reset_email }

  #json_spec
  config.include JsonHelpers

  #for invalid api requests
  config.include ApiHelpers

  config.before :each do
    @session = Capybara::Session.new(:selenium)
  end



end
