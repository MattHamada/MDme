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

  def get_upcoming_appointment

    @upcoming_appointment = @patient.upcoming_appointment
    respond_to do |format|
      format.json do
        if @upcoming_appointment
          render json:  get_appointment_progress_bar_json(@upcoming_appointment)
        else
          render json: {}
        end
      end
      format.html do
        get_appointment_progress_bar(@upcoming_appointment) unless @upcoming_appointment.nil?
      end
    end
  end

  def get_appointment_progress_bar_json(upcoming_appointment)
    results = {
        date: upcoming_appointment.date,
        time: upcoming_appointment.delayed_time_ampm
    }
    minutes_left =
        ((upcoming_appointment.appointment_delayed_time - DateTime.now) / 60).to_i
    results[:minutesLeft] = minutes_left
    results[:percent] = 100-minutes_left
    case minutes_left
      when 21..120
        results[:color] = 'success'
      when 6..20
        results[:color] = 'warning'
      when 0..5
        results[:color] = 'danger'
      else
        results[:color] = 'success'
        results[:percent] = 0
    end
    if minutes_left < 60
      results[:timeLeft] = "#{minutes_left} minutes until appointment"
    else
      hours_left = minutes_left / 60
      if hours_left == 1 then h = 'hour' else h = 'hours' end
      results[:timeLeft] =
          "#{minutes_left / 60} #{h} and #{minutes_left % 60} minutes left"
    end
    results[:barClass] = 'progress-bar-' + results[:color]
    results[:timeLeft] = minutes_left.to_s + 'minutes until appointment'
    results.json
  end

  def get_appointment_progress_bar(upcoming_appointment)
    @minutes_left =
        ((upcoming_appointment.appointment_delayed_time - DateTime.now) / 60).to_i
    @percent = 120 - @minutes_left
    case @minutes_left
      when 26...120
        @color = 'info'
      # when 70..81
      #   @color = 'info'
      # when 60...69
      #   @color = 'info'
      # when 35...59
      #   @color = 'info'
      # when 21...34
      #   @color = 'info'
      when 6...25
        @color = 'warning'
      when 0...5
        @color = 'danger'
      else
        @color = 'info'
        @percent = 0
    end

    if @minutes_left < 60
      @humanized_time_left = "#{@minutes_left} minutes until appointment"
    else
      hours_left = @minutes_left / 60
      if hours_left == 1 then h = 'hour' else h = 'hours' end
      @humanized_time_left =
          "#{@minutes_left / 60} #{h} and #{@minutes_left % 60} minutes left"
    end
  end

  protected
    def authenticate_header
      begin
        token = request.headers['Authorization'].split(' ').last
        payload, header = AuthToken.valid?(token)
        @patient = Patient.find_by(id: payload['user_id'])
        params[:patient_id] = @patient.id
      rescue
        render json: { error: 'Could not authenticate your request.  Please login'},
               status: :unauthorized
      end
    end

    def authenticate_admin_header
      begin
        token = request.headers['Authorization'].split(' ').last
        payload, header = AuthToken.valid?(token)
        @admin = Admin.find_by(id: payload['admin_id'])
      rescue
        render json: { error: 'Could not authenticate your request.  Please login'},
               status: :unauthorized
      end
    end

    def poly_authenticate_header
      begin
        token = request.headers['Authorization'].split(' ').last
        payload, header = AuthToken.valid?(token)
        if payload.has_key? 'admin_id'
          @admin = Admin.find_by(id: payload['admin_id'])
        elsif payload.has_key? 'user_id'
          @patient = Patient.find_by(id: payload['user_id'])
        end
      rescue
        render json: { error: 'Could not authenticate your request.  Please login'},
               status: :unauthorized
      end
    end

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

