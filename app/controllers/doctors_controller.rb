# Author: Matt Hamada
# Copyright MDme 2014
#
# Controller for handing doctor subdomain
#


class DoctorsController < ApplicationController
  before_filter :require_admin_login, :only => [:new,  :destroy, :index]
  before_filter :require_doctor_login, :only => [:appointments]
  before_filter :require_admin_or_doctor_login, :only => [:edit, :show]

  #TODO allow doctor to change password

  def signin
    if doctor_signed_in?
      redirect_to doctors_appointments_path(current_doctor)
    end
  end

  def index
    current_user = current_admin if request.subdomain == 'admin' else current_patient
    @doctors = Doctor.in_clinic(current_user).includes(:department)
    render 'admins/doctors_index' if request.subdomain == 'admin'
  end

  def new
    @doctor = Doctor.new
    render 'admins/doctors_new'
  end

  def create
    p = doctor_params
    p[:password] =  p[:password_confirmation] = generate_random_password
    @doctor = Doctor.new(p, is_admin_applying_update: true)
    @doctor.clinic_id = current_admin.clinic_id

    if @doctor.save
      Thread.new do
        SignupMailer.signup_confirmation(@doctor, p[:password]).deliver
      end

      flash[:success] = 'Doctor Successfully Created.'
      redirect_to doctors_path
    else
      render 'admins/doctors_new'
    end

  end

  def edit
    @doctor = doctor
    render 'admins/doctors_edit' if request.subdomain == 'admin'
  end

  def update
    @doctor = doctor
    @doctor.is_admin_applying_update = true if request.subdomain == 'admin'
    unless @doctor.is_admin_applying_update
      if @doctor.authenticate(params[:verify][:verify_password]) == false
        flash[:danger] = 'Invalid password entered.'
        redirect_to edit_doctor_path(@doctor)
      else
        #skip password validation since password checked correct
        @doctor.is_admin_applying_update = true
      end


    end

    dp = doctor_params
    #dp[:password] = params[:verify][:verify_password]
    #dp[:password_confirmation] = params[:verify][:verify_password]

    @doctor.attributes = dp


    if @doctor.save
      flash[:success] = "Doctor Successfully Updated"
      if request.subdomain == 'admin'
        redirect_to doctors_path
      else
        redirect_to doctor_path(@doctor)
      end
    else
      #check needed to avoid calling redirect above
      # when password is invalid and render below
      if @doctor.is_admin_applying_update
        flash.now[:danger] = 'Invalid Parameters Entered'
        if request.subdomain == 'doctors'
          render 'edit'
        elsif request.subdomain == 'admin'
          render 'admins/doctors_edit'
        end
      end
    end


  end

  def doctor_params
    params.require(:doctor).permit(:first_name, :last_name, :email, :department_id, :phone_number, :degree,
                                   :alma_mater, :description, :password, :password_confirmation, :avatar)
  end

  def destroy
    @doctor = doctor
    @doctor.destroy!
    flash[:warning] = 'Doctor Successfully Deleted'
    redirect_to doctors_path
  end

  def show
    @doctor = doctor
  end

  # shows doctor's confirmed appointments
  def appointments
    @doctor = doctor
    @appointments = Appointment.given_date(Date.today).confirmed.with_doctor(params[:id]).order('appointment_time ASC').load
  end

  # shows Doctor's patients
  def patient_index
    @doctor = doctor
    @patients = @doctor.patients
  end

  private

  def doctor
    @doctor ||= Doctor.find_by_slug!(params[:id])
  end

  helper_method :doctor
end
