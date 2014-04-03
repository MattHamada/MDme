class Admins::DoctorsController < ApplicationController

  before_filter :find_admin
  before_filter :find_doctor, only: [:edit, :update, :show, :destroy]
  before_filter :require_admin_login

  #TODO clicking doctor in list should open public profile ajax not edit page
  def index
    @doctors = Doctor.in_clinic(@admin).includes(:department)
  end

  def new
    @current_user = @admin
    @doctor = Doctor.new
  end

  def create
    @current_user = @admin
    p = doctor_params
    p[:password] =  p[:password_confirmation] = generate_random_password
    @doctor = Doctor.new(p, is_admin_applying_update: true)
    @doctor.clinic_id = @admin.clinic_id

    if @doctor.save
      flash[:success] = 'Doctor Successfully Created.'
      redirect_to admin_doctors_path(@admin)
    else
      flash[:danger] = 'Error creating doctor'
      render 'new'
    end

  end

  def edit
    @current_user = @admin
  end

  def update
    @current_user = @admin
    @doctor.is_admin_applying_update = true
    dp = doctor_params
    @doctor.attributes = dp
    if @doctor.save
      flash[:success] = "Doctor Successfully Updated"
      redirect_to admin_doctors_path(@admin)
    else
      flash.now[:danger] = 'Invalid Parameters Entered'
      render 'edit'
    end
  end

  def show
  end

  def destroy
    if @doctor.destroy
      flash[:warning] = 'Doctor deleted'
      redirect_to admin_doctors_path(@admin)
    else
      flash.now[:danger] = 'An error has occurred'
      render admin_doctor_path(@admin, @doctor)
    end
  end



  private

    def doctor_params
      params.require(:doctor).permit(:first_name, :last_name, :email,
                                     :department_id, :phone_number, :degree,
                                     :alma_mater, :description, :password,
                                     :password_confirmation, :avatar)
    end

    def find_doctor
      @doctor ||= Doctor.find_by_slug(params[:id])
    end
    helper_method :find_doctor

    def find_admin
      @admin ||= Admin.find(params[:admin_id])
    end
    helper_method :find_admin
end