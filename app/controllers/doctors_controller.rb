# Author: Matt Hamada
# Copyright MDme 2014
#
# Controller for handing doctor subdomain
#


class DoctorsController < ApplicationController

  before_filter :find_doctor, except: [:signin]
  before_filter :require_doctor_login, except: [:signin]

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
