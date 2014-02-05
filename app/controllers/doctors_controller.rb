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
    @doctors = Doctor.all
    render 'admins/doctors_index' if request.subdomain == 'admin'
  end

  def new
    @doctor = Doctor.new
    render 'admins/doctors_new'
  end

  def create
    p = doctor_params
    p[:password] = 'temppass'
    p[:password_confirmation]  = 'temppass'
    @doctor = Doctor.new(p)

    if @doctor.save
      flash[:success] = 'Doctor Successfully Created.'
      redirect_to admins_path
    else
      flash.now[:danger] = 'Invalid Parameters Entered'
      render 'admins/doctors_new'
    end
  end

  def edit
    @doctor = Doctor.find(params[:id])
    render 'admins/doctors_edit' if request.subdomain == 'admin'
  end

  def update
    @doctor = Doctor.find(params[:id])
    @doctor.is_admin_applying_update = true if request.subdomain == 'admin'
    if @doctor.authenticate(params[:verify][:verify_password]) == false
      flash[:danger] = 'Invalid password entered.'
      redirect_to edit_doctor_path(@doctor)
    else
      dp = doctor_params
      puts dp
      dp[:password] = params[:verify][:verify_password]
      dp[:password_confirmation] = params[:verify][:verify_password]
      puts 'ssssssss'
      @doctor.attributes = dp
      puts dp
      puts @doctor.attributes

      if @doctor.save
        flash[:success] = "Doctor Successfully Updated"
        if request.subdomain == 'admin'
          redirect_to admins_path
        else
          redirect_to doctor_path(@doctor)
        end
      else
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
    @doctor = Doctor.find(params[:id])
    @doctor.destroy!
    flash[:warning] = 'Doctor Successfully Deleted'
    redirect_to admins_path
  end

  def show
    @doctor = Doctor.find(params[:id])
  end

  def appointments
    @doctor = Doctor.find(params[:id])
    @appointments = Appointment.given_date(Date.today).with_doctor(params[:id]).order('appointment_time ASC').load
  end

  def patient_index
    @doctor = Doctor.find(params[:id])
    @patients = Doctor.find(params[:id]).patients
  end
end
