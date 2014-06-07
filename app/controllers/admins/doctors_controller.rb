class Admins::DoctorsController < ApplicationController

  before_filter :find_admin
  before_filter :find_doctor, only: [:edit, :update, :show, :destroy]
  before_filter :require_admin_login

  def index
  end

  def new
    @current_user = @admin
    @doctor = Doctor.new
    @doctor.department_id = params[:department_id] unless params[:department_id].nil?
  end

  def create
    @current_user = @admin
    p = doctor_params
    p[:password] =  p[:password_confirmation] = generate_random_password
    @doctor = Doctor.new(p, bypass_password_validation: true)
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
    @doctor.bypass_password_validation = true
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
    render partial: 'admins/doctors/ajax_show', object: @doctor if request.xhr?
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

  def search
    @doctors = Doctor.in_clinic(@admin).includes(:department)
    @doctors = @doctors.where("lower(last_name) = ?", params[:doctor][:last_name].downcase).includes(:department) unless params[:doctor][:last_name].empty?
    @doctors = @doctors.where("lower(first_name) = ?", params[:doctor][:first_name].downcase).includes(:department) unless params[:doctor][:first_name].empty?
    @doctors = @doctors.where(department:  Department.where("lower(name) = ?", params[:doctor][:department].downcase).in_clinic(@admin).first).includes(:department) unless params[:doctor][:department].empty?
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