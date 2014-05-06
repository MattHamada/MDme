# Author: Matt Hamada
# Copyright MDme 2014
#
# Controller for handing doctor subdomain
#


class DoctorsController < ApplicationController

  before_filter :find_doctor, except: [:signin, :open_appointments]
  before_filter :require_doctor_login, except: [:signin, :open_appointments]

  def signin
    if doctor_signed_in?
      redirect_to doctor_path(current_doctor)
    end
  end

  def index
    @doctors = Doctor.in_clinic(@doctor).includes(:department)
  end

  def edit
    @current_user = @doctor
  end

  def update
    @current_user = @doctor
    if @doctor.authenticate(params[:verify][:verify_password])
      #skip password validation since password checked correct
      @doctor.is_admin_applying_update = true
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

  def show
  end

  def change_password
  end

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

  def open_appointments
    input = params[:appointment]
    @date = Date.parse(input[:date])
    #clinic_name only present on patient page
    @clinic_id = 0
    if  !input[:clinic_name].empty?
      @clinic_id = Clinic.find_by_name(input[:clinic_name]).id
    else
      @clinic_id = input[:clinic_id]
    end
    @doctor = Doctor.find_by_full_name(input[:doctor_full_name], @clinic_id)
    @open_times = @doctor.open_appointment_times(@date)
    #@appointment = Appointment.new
    render json: {open_times: @open_times}
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
