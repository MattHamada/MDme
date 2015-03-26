# MDme Rails master application
# Author:: Matt Hamada (maito:mattahamada@gmail.com)
# 10/23/13
# Copyright:: Copyright (c) 2014 MDme
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential.


# +ApplicationController+ master controller
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include SessionsHelper

  before_action :set_variant
  before_filter :expire_hsts


  after_filter :set_csrf_cookie_for_ng

  def set_csrf_cookie_for_ng
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end

  # Used to define if user is on mobile browser
  def set_variant
    if  request.user_agent =~
        /mobile|android|touch|webos|hpwos|iphone|iPhone|iPad|ipod|
         android|blackberry|opera|mini|windows\sce|palm|smartphone|iemobile|
         ipad|android 3.0|xoom|sch-i800|playbook|tablet|kindle/

      request.variant = :mobile
    else
      request.variant = :desktop
    end
  end

  # # Used for making ajax calls between subdomains
  # def allows_cors
  #   headers['Access-Control-Allow-Origin'] = '*'
  #   headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
  #   headers['Access-Control-Request-Method'] = '*'
  #   headers['Access-Control-Allow-Headers'] =
  #       'Origin, X-Requested-With, Content-Type, Accept, Authorization'
  # end

  # Sets bootstrap variables for filling and coloring the progress bar
  # success is green; warning is yellow; danger is red

  protected

    def verified_request?
      super || valid_authenticity_token?(session, request.headers['X-XSRF-TOKEN'])
    end

  private
    # Makes browsers not think site is sketchy when ssl turned off.
    # Disable this when ssl back on
    def expire_hsts
      response.headers["Strict-Transport-Security"] = 'max-age=0' if
          Rails.env.production?
    end


end

