# MDme Rails master application
# Author:: Matt Hamada (maito:mattahamada@gmail.com)
# 10/29/13
# Copyright:: Copyright (c) 2014 MDme
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential.

# +PatientsController+ for handling Patient pages on default subdomain (www)
# www.mdme.us/patients
class PatientsController < ApplicationController

  # before_filter :find_patient
  # before_filter :require_patient_login
  # before_filter :get_upcoming_appointment

  before_action :authenticate_header

  # GET www.mdme.us/patients/:id
  def show
    # respond_to do |format|
    #   format.html do |variant|
    #     variant.mobile { render 'patients/mobile/show' }
    #   end
    #   format.json  { render :json => @patient, except: [:created_at,
    #                                                     :updated_at,
    #                                                     :password_digest,
    #                                                     :remember_token] }
    # end
  end

  # GET www.mdme.us/patients/:id/edit
  def edit
    add_breadcrumb 'Home', patients_path
    add_breadcrumb 'My Profile', patient_path(@patient)
    add_breadcrumb 'Edit Profile', edit_patient_path(@patient)
    @active = :profile
    @current_user = @patient
  end

  # POST www.mdme.us/patients/:id
  def update
    unless params[:patient].nil?
      p = patient_params
      if p.has_key? :password and @patient.authenticate(p[:password])
      @patient.attributes = p

      if @patient.save
        render json: { status: 'patient updated' }
      else
        render status: 400, json: { status: 'error', errors: @patient.errors.full_messages }
      end
      else
        render status: 401, json: { status: 'error', errors: 'Invalid password entered' }
      end
    else
      render status: 401, json: { status: 'error', errors: 'No password entered' }
    end

  end

  # GET www.mdme.us/patients
  def index
    @active = :home
    add_breadcrumb 'Home', patients_path
  end

  # GET www.mdme.us/patients/:id/changepassword
  def change_password
    @active = :profile
    add_breadcrumb 'Home', patients_path
    add_breadcrumb 'My Profile', patient_path(@patient)
    add_breadcrumb 'Change Password', patient_password_path(@patient)
  end

  # PATCH www.mdme.us/patients/:id/updatepassword
  def update_password
    if @patient.authenticate(params[:oldPassword])
      if @patient.update_attributes(password: params[:newPassword],
                                   password_confirmation: params[:newPasswordConf])
        render status: 201, json: {status: 'Password Changed'}
      else
        render status: 401, json:{status: @patient.errors.full_messages[0]}
      end
    else
      render status: 401, json: {status: 'Old password invalid'}
    end
  end

  def get_upcoming_appointment
    upcoming_appointment = @patient.upcoming_appointment
    if upcoming_appointment
      render json:  get_appointment_progress_bar(upcoming_appointment).to_json
    else
      render json: {}
    end
  end

  #mobile stuff below

  def menu
    render 'patients/mobile/menu'
  end

  private

    def patient_params
      params.require(:patient).permit(:first_name,
                                      :last_name,
                                      :middle_initial,
                                      :name_prefix,
                                      :name_suffix,
                                      :birthday,
                                      :email,
                                      :password,
                                      :password_confirmation,
                                      :doctor_id,
                                      :home_phone,
                                      :work_phone,
                                      :mobile_phone,
                                      :work_phone_extension,
                                      :sex,
                                      :social_security_number,
                                      :marital_status,
                                      :address1,
                                      :address2,
                                      :city,
                                      :state,
                                      :zipcode,
                                      :avatar)
      end

    # def find_patient
    #   @patient ||= current_patient || Patient.find_by_slug!(params[:id])
    # end
    # helper_method :find_patient

    #TODO might belong in appointment model
    def get_appointment_progress_bar(upcoming_appointment)
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
      results
    end




end
