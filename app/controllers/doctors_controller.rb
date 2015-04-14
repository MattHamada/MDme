# MDme Rails master application
# Author:: Matt Hamada (maito:mattahamada@gmail.com)
# 10/30/13
# Copyright:: Copyright (c) 2014 MDme
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential.

# +DoctorsController+ for handing doctors subdomain doctors.mdme.us/doctors
#
class DoctorsController < ApplicationController

  before_filter :find_doctor, except: [:signin, :open_appointments]
  before_filter :require_doctor_login, except: [:signin, :open_appointments]

  # Cannot access sign in page while signed in.  Will redirect to #show
  # GET doctors.mdme.us/signin
  def signin
    if doctor_signed_in?
      redirect_to doctor_path(current_doctor)
    end
  end

  # Shows all doctors in the clinic of the logged in doctor
  # GET doctors.mdme.us/doctors
  def index
    @doctors = Doctor.in_clinic(@doctor).includes(:department)
  end

  # GET doctors.mdme.us/doctors/:id/edit
  def edit
    @current_user = @doctor
  end

  # PATCH doctors.mdme.us/doctors/:id
  def update
    @current_user = @doctor
    if @doctor.authenticate(params[:verify][:verify_password])
      #skip password validation since password checked correct
      @doctor.bypass_password_validation = true
      dp = doctor_params
      @doctor.attributes = dp
      if @doctor.save
        flash[:success] = "Doctor Successfully Updated"
        redirect_to doctor_path(@doctor)
      else
        flash.now[:danger] = 'Invalid Parameters Entered'
        render 'edit'
      end
    else
      flash[:danger] = 'Invalid password entered.'
      render 'edit'
    end

  end

  # GET doctors.mdme.us/doctors/:id
  def show
  end

  # GET doctors.mdme.us/doctors/:id/changepassword
  def change_password
  end

  # POST doctors.mdme.us/doctors/:id/updatepassword
  def update_password
    if @doctor.authenticate(params[:old_password])
      if @doctor.update_attributes(password: params[:new_password],
                                   password_confirmation: params[:new_password_confirm])
        flash[:success] = 'Password updated'
        redirect_to doctor_path(@doctor)
      else
        flash.now[:danger] = 'Unable to change password'
        render 'change_password'
      end
    else
      flash[:danger] = 'Old password invalid'
      render 'change_password'
    end
  end

  #TODO move to an API controller?
  #TODO rename method or route to be the same
  #TODO should really be part of clinic::doctors since doctor could work multiple places
  # API orphan to get open appointment times for a given doctor for
  # creating appointments
  # GET doctors.mdme.us/doctors/opentimes
  def open_appointments
    date = Date.parse(params[:date])
    clinic = Clinic.find(params[:clinic_id])
    doctor = Doctor.find(params[:doctor_id])
    # @times = doctor.open_appointment_times(date)
    @times = clinic.open_appointment_times(date, doctor)
    if @times.is_a?(Hash)
      render json: {status: 1, error: @times[:error]}
    else
      render json: { status: 0, times: @times }
    end
    #@appointment = Appointment.new
    #render json: {open_times: @open_times}
    # render json: {times: [
    #     {time: '8:00 AM', enabled: true, selected: false, index: 0},
    #     {time: '8:30 AM', enabled: false, selected: false, index: 1},
    #     {time: '9:00 AM', enabled: true, selected: false, index: 2},
    #     {time: '9:30 AM', enabled: true, selected: false, index: 3},
    #     {time: '10:00 AM', enabled: false, selected: false, index: 4},
    #     {time: '10:30 AM', enabled: false, selected: false, index: 5},
    #     {time: '11:00 AM', enabled: false, selected: false, index: 6},
    #     {time: '11:30 AM', enabled: true, selected: false, index: 7},
    #     {time: '12:00 PM', enabled: true, selected: false, index: 8},
    #     {time: '12:30 PM', enabled: true, selected: false, index: 9},
    #     {time: '1:00 PM', enabled: false, selected: false, index: 10},
    #     {time: '1:30 PM', enabled: true, selected: false, index: 11},
    #     {time: '2:00 PM', enabled: false, selected: false, index: 12},
    #     {time: '2:30 PM', enabled: false, selected: false, index: 13},
    #     {time: '3:00 PM', enabled: true, selected: false, index: 14},
    #     {time: '3:30 PM', enabled: true, selected: false, index: 15},
    #     {time: '4:00 PM', enabled: true, selected: false, index: 16},
    #     {time: '4:30 PM', enabled: false, selected: false, index: 17},
    #     {time: '5:00 PM', enabled: true, selected: false, index: 18},
    #     {time: '5:30 PM', enabled: true, selected: false, index: 19}]}

  end

  private

    def doctor_params
      params.require(:doctor).permit(:first_name, :last_name, :email,
                                     :department_id, :phone_number, :degree,
                                     :alma_mater, :description, :password,
                                     :password_confirmation, :avatar)
    end

    def find_doctor
      @doctor ||= Doctor.find_by_slug!(params[:id])
    end

  helper_method :find_doctor
end
