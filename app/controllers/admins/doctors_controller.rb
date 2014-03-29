class Admins::DoctorsController < ApplicationController

  def index
    @admin = admin
    @doctors = Doctor.in_clinic(@admin).includes(:department)
  end

  def new
    @admin = @current_user = admin
    @doctor = Doctor.new
  end

  def create
    @admin = @current_user = admin
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
    @admin = @current_user = admin
    @doctor = doctor
  end

  def update
    @admin = @current_user = admin
    @doctor = doctor
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
    @admin = admin
    @doctor = doctor
  end

  def destroy
    @admin = admin
    @doctor = doctor

    if @doctor.destroy
      flash[:warning] = 'Doctor deleted'
      redirect_to admin_doctors_path(@admin)
    else
      flash.now[:danger] = 'An error has occurred'
      render admin_doctor_path(@admin, @doctor)
    end
  end

  def doctor_params
    params.require(:doctor).permit(:first_name, :last_name, :email,
                                   :department_id, :phone_number, :degree,
                                   :alma_mater, :description, :password,
                                   :password_confirmation, :avatar)
  end

  private

    def doctor
      @doctor ||= Doctor.find_by_slug(params[:id])
    end
    helper_method :doctor

    def admin
      @admin ||= Admin.find(params[:admin_id])
    end
end