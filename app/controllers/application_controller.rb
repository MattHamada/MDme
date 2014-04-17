# Author: Matt Hamada
# Copyright MDme 2014
#

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include SessionsHelper

  before_action :set_variant

  def set_variant
    if  request.user_agent =~
        /mobile|android|touch|webos|hpwos|iphone|ipod|android|blackberry|opera|mini|windows\sce|palm|smartphone|iemobile|ipad|android 3.0|xoom|sch-i800|playbook|tablet|kindle/

      request.variant = :mobile
    else
      request.variant = :desktop
    end

  end
end

