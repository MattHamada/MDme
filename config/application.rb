require File.expand_path('../boot', __FILE__)


# Pick the frameworks you want:
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'sprockets/railtie'
# require './lib/rack/restful_jsonp_middleware'

# require "rails/test_unit/railtie"


# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)


#load yaml stored settings
['../email_config.yml', '../api_keys.yml', '../encryption_keys.yml'].each do |yml|
  config = YAML.load(File.read(File.expand_path(yml, __FILE__)))
  config.merge! config.fetch(Rails.env, {})
  config.each do |key, value|
    ENV[key] = value.to_s unless value.kind_of? Hash
  end
end


module MDme
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.assets.paths << "#{Rails.root}/app/assets/fonts"
    config.assets.paths << Rails.root.join("vendor","assets","bower_components")
    config.assets.paths << Rails.root.join("vendor","assets","bower_components","bootstrap-sass-official","assets","fonts")
    #for fonts
    config.assets.precompile << Proc.new { |path|
      if path =~ /\.(eot|svg|ttf|woff)\z/
        true
      end
    }

    #set default time zone - used for appointments
    config.time_zone = 'Arizona'
    config.active_record.default_timezone = :local

    #config.assets.paths << "#{Rails}/vendor/assets/fonts"

    #autoload files in /lib for use in other classes
    #config.autoload_paths += Dir["#{config.root}/lib", "#{config.root}/lib/**/"]
    config.autoload_paths += %W(#{config.root}/lib)
    config.autoload_paths += Dir["#{config.root}/lib/**/"]

    #prevent email from being logged
    config.action_mailer.logger = nil

    #Allow jsonp non-get http requests
    # config.middleware.swap(Rack::MethodOverride,Rack::RestfulJsonpMiddleware)

    #pushmeup settings for android
    GCM.host = 'https://android.googleapis.com/gcm/send'
    GCM.format = :json
    GCM.key = ENV['GCM_API_KEY']

  end
end

