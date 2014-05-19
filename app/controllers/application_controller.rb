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
        /mobile|android|touch|webos|hpwos|iphone|iPhone|iPad|ipod|android|blackberry|opera|mini|windows\sce|palm|smartphone|iemobile|ipad|android 3.0|xoom|sch-i800|playbook|tablet|kindle/

      request.variant = :mobile
    else
      request.variant = :desktop
    end
  end

  def allows_cors
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
  end

  def get_appointment_progress_bar(upcoming_appointment)
    minutes_left = ((upcoming_appointment.appointment_delayed_time - DateTime.now) / 60).to_i
    case minutes_left
      when 0...5
        @color = 'danger'
        @percent = 90
      when 6...20
        @color = 'warning'
        @percent = 80
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
      when 21...35
        @color = 'success'
        @percent = 75
    end
    if minutes_left < 60
      @humanized_time_left = "#{minutes_left} minutes until appointment"
    else
      hours_left = minutes_left / 60
      if hours_left == 1 then h = 'hour' else h = 'hours' end
      @humanized_time_left = "#{minutes_left / 60} #{h} and #{minutes_left % 60} minutes left"
    end
  end


end

