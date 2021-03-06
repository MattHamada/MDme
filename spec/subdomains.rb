# Support for Rspec / Capybara subdomain integration testing
# Make sure this file is required by spec_helper.rb
#
# Sample subdomain test:
# it "should test subdomain" do
#   switch_to_subdomain("mysubdomain")
#   visit root_path
# end

DEFAULT_HOST = 'mdme.tk'
DEFAULT_PORT = 7171

RSpec.configure do |config|
  Capybara.default_host = "http://#{DEFAULT_HOST}"
  Capybara.server_port = DEFAULT_PORT
  Capybara.app_host = "http://#{DEFAULT_HOST}:#{Capybara.server_port}"

  # rspec-rails 3 will no longer automatically infer an example group's spec type
  # from the file location. You can explicitly opt-in to the feature using this
  # config option.
  # To explicitly tag specs without using automatic inference, set the `:type`
  # metadata manually:
  #
  #     describe ThingsController, :type => :controller do
  #       # Equivalent to being in spec/controllers
  #     end
  config.infer_spec_type_from_file_location!
end

def switch_to_subdomain(subdomain)
  Capybara.app_host = "http://#{subdomain}.#{DEFAULT_HOST}:#{DEFAULT_PORT}"
end