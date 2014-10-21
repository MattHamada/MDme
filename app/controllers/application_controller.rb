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
  #TODO make base apiapplicatoncontroller with null session enabled
  protect_from_forgery with: :exception

  include SessionsHelper

  before_action :set_variant
  before_filter :expire_hsts

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

  # Used for making ajax calls between subdomains
  def allows_cors
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] =
        'Origin, X-Requested-With, Content-Type, Accept, Authorization'
  end

  # Sets bootstrap variables for filling and coloring the progress bar
  # success is green; warning is yellow; danger is red
  def get_appointment_progress_bar(upcoming_appointment)
    minutes_left =
      ((upcoming_appointment.appointment_delayed_time - DateTime.now) / 60).to_i
    case minutes_left
      when 81...120
        @color = 'success'
        @percent = 20
      when 70..81
        @color = 'success'
        @percent = 40
      when 60...69
        @color = 'success'
        @percent = 50
      when 35...59
        @color = 'success'
        @percent = 65
      when 21...34
        @color = 'success'
        @percent = 75
      when 6...20
        @color = 'warning'
        @percent = 80
      when 0...5
        @color = 'danger'
        @percent = 90
      else
        @color = 'success'
        @percent = 0
    end
    if minutes_left < 60
      @humanized_time_left = "#{minutes_left} minutes until appointment"
    else
      hours_left = minutes_left / 60
      if hours_left == 1 then h = 'hour' else h = 'hours' end
      @humanized_time_left =
          "#{minutes_left / 60} #{h} and #{minutes_left % 60} minutes left"
    end
  end

  private
    def expire_hsts
      response.headers["Strict-Transport-Security"] = 'max-age=0' if
          Rails.env.production?
    end


end

