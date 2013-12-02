class DoctorsController < ApplicationController
  before_filter :require_admin_login, :only => [:new, :edit, :destroy, :index]


  def home

  end

  def signin

  end

  def index
    @doctors = Doctor.all
  end

  def new
    @doctor = Doctor.new
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
      render 'new'
    end
  end

  def edit
    @doctor = Doctor.find(params[:id])
  end

  def update
    @doctor = Doctor.find(params[:id])
    @doctor.is_admin_applying_update = true if request.subdomain == 'admin'
    @doctor.attributes = doctor_params
    if @doctor.save
      flash[:success] = "Doctor Successfully Updated"
      redirect_to admins_path
    else
      flash.now[:danger] = 'Invalid Parameters Entered'
      render 'new'
    end
  end

  def doctor_params
    params.require(:doctor).permit(:first_name, :last_name, :email, :department_id, :password, :password_confirmation)
  end

  def destroy
    @doctor = Doctor.find(params[:id])
    @doctor.destroy!
    flash[:warning] = 'Doctor Successfully Deleted'
    redirect_to admins_path
  end

  def show
    @appointments = Appointment.given_date(Date.today).with_doctor(params[:id]).order('appointment_time ASC').load
  end
end
