# MDme Rails master application
# Author:: Matt Hamada (maito:mattahamada@gmail.com)
# 3/29/14
# Copyright:: Copyright (c) 2014 MDme
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential.

# <tt>Admins::DoctorsController</tt> for admin.mdme.us/admins/:admin_id/clinics
class Admins::DoctorsController < ApplicationController

  # before_filter :find_admin
  # before_filter :find_doctor, only: [:edit, :update, :show, :destroy]
  # before_filter :require_admin_login
  before_action :authenticate_admin_header


  # GET admin.mdme.us/admins/:admin_id/doctors
  def index
    @doctors = Doctor.in_clinic(@admin.clinic)

  end

  # GET admin.mdme.us/admins/:admin_id/doctors/new
  def new
    @current_user = @admin
    @doctor = Doctor.new
    @doctor.department_id = params[:department_id] unless params[:department_id].nil?
  end

  #POST admin.mdme.us/admins/:admin_id/doctors
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

  # GET admin.mdme.us/admins/:admin_id/doctors/:id/edit
  def edit
    @current_user = @admin
  end

  # POST admin.mdme.us/admins/:admin_id/doctors/:id
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

  # GET admin.mdme.us/admins/:admin_id/doctors/:id
  def show
    render partial: 'admins/doctors/ajax_show', object: @doctor if request.xhr?
  end

  # DELETE admin.mdme.us/admins/:admin_id/doctors/:id
  def destroy
    if @doctor.destroy
      flash[:warning] = 'Doctor deleted'
      redirect_to admin_doctors_path(@admin)
    else
      flash.now[:danger] = 'An error has occurred'
      render admin_doctor_path(@admin, @doctor)
    end
  end

  # Allows searching for doctor(s) by department, first name, and/or last name
  # GET admin.mdme.us/admins/:admin_id/doctors/search
  def search
    @doctors = Doctor.in_clinic(@admin).includes(:department)
    @doctors = @doctors.where(
        "lower(last_name) = ?", params[:doctors][:last_name].downcase).
        includes(:department) unless params[:doctors][:last_name].empty?
    @doctors = @doctors.where(
        "lower(first_name) = ?", params[:doctors][:first_name].downcase).
        includes(:department) unless params[:doctors][:first_name].empty?
    @doctors = @doctors.where(
        department:  Department.where(
            "lower(name) = ?", params[:doctors][:department].downcase).
            in_clinic(@admin).first).includes(:department) unless
                params[:doctors][:department].empty?
  end





  private

    def doctor_params
      params.require(:doctors).permit(:first_name, :last_name, :email,
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