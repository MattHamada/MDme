# Author: Matt Hamada
# Copyright MDme 2014
#
# Controller for handing doctor subdomain
#


class DoctorsController < ApplicationController
  before_filter :require_admin_login, :only => [:new,  :destroy]
  before_filter :require_doctor_login, :only => [:appointments]
  before_filter :require_admin_or_doctor_login, :only => [:edit]
  before_filter :require_login, only: [:show, :index]

  def signin
    if doctor_signed_in?
      redirect_to doctor_path(current_doctor)
    end
  end

  def index
    @doctor = doctor
    @doctors = Doctor.in_clinic(@doctor).includes(:department)
  end

  # def new
  #   @doctor = Doctor.new
  #   @doctor.department_id = params[:department_id] unless params[:department_id].nil?
  #   render 'admins/doctors_new'
  # end

  # def create
  #   p = doctor_params
  #   p[:password] =  p[:password_confirmation] = generate_random_password
  #   @doctor = Doctor.new(p, is_admin_applying_update: true)
  #   @doctor.clinic_id = current_admin.clinic_id
  #
  #   if @doctor.save
  #     flash[:success] = 'Doctor Successfully Created.'
  #     redirect_to doctors_path
  #   else
  #     render 'admins/doctors_new'
  #   end
  #
  # end

  def edit
    @doctor = @current_user = doctor
  end

  def update
    @doctor = @current_user = doctor
    if @doctor.authenticate(params[:verify][:verify_password])
      #skip password validation since password checked correct
      @doctor.is_admin_applying_update = true
    else
      flash[:danger] = 'Invalid password entered.'
      #TODO stop flow here if passwrod invalid
    end
    dp = doctor_params
    @doctor.attributes = dp
    if @doctor.save
      flash[:success] = "Doctor Successfully Updated"
      redirect_to doctor_path(@doctor)
    else
        flash.now[:danger] = 'Invalid Parameters Entered'
        render 'edit'
    end
  end

  # def destroy
  #   @doctor = doctor
  #   @doctor.destroy!
  #   flash[:warning] = 'Doctor Successfully Deleted'
  #   redirect_to doctors_path
  # end

  def show
    @doctor = doctor
  end

  def change_password
    @doctor = doctor

  end

  def update_password
    @doctor = doctor
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


  def doctor_params
    params.require(:doctor).permit(:first_name, :last_name, :email,
                                   :department_id, :phone_number, :degree,
                                   :alma_mater, :description, :password,
                                   :password_confirmation, :avatar)
  end

  private

  def doctor
    @doctor ||= Doctor.find_by_slug!(params[:id])
  end

  helper_method :doctor
end
