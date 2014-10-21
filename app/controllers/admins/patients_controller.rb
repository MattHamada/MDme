# MDme Rails master application
# Author:: Matt Hamada (maito:mattahamada@gmail.com)
# 3/29/14
# Copyright:: Copyright (c) 2014 MDme
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential.

# <tt>Admins::DepartmentsController</tt> for admin.mdme.us/departments
class Admins::PatientsController < ApplicationController

  before_filter :find_admin
  before_filter :find_patient, only: [:show, :edit, :update, :destroy]
  before_filter :require_admin_login

  def index
    @patients = Patient.in_clinic(@admin).ordered_last_name #.includes(:doctor)
  end

  def new
    @current_user = @admin
    @patient = Patient.new
  end

  def create
    @current_user = @admin
    p = patient_params
    p[:password] = p[:password_confirmation] = generate_random_password
    p[:doctor_id] = params[:doctor][:doctor_id]
    @patient = Patient.new(p)
    @patient.clinics <<  Clinic.find(@admin.clinic_id)
    if @patient.save
      flash[:success] = 'Patient Created'
      redirect_to admin_patients_path
    else
      flash.now[:danger] = 'Error Creating Patient'
      render 'new'
    end
  end

  def show
    render partial: 'admins/patients/ajax_show', object: @patient if request.xhr?
  end

  def edit
    @current_user = @admin
  end

  def update
    @patient.bypass_password_validation = true
    @patient.attributes = patient_params
    if @patient.save
      flash[:success] = 'Patient Successfully Updated'
      redirect_to admin_patients_path(@admin)
    else
      flash.now[:danger] = 'Invalid Parameters Entered'
      render edit_admin_patient_path(@admin, @patient)
    end
  end

  def destroy
    id = @patient.id
    if @patient.destroy
      flash[:warning] = 'Patient deleted'
      redirect_to admin_patients_path
    else
      flash.now[:danger] = 'An error has occured'
      render admin_patient_path(@patient)
    end
  end

  # Allows searching for doctor(s) by id, dob, first name, and/or last name
  def search
    @patients = Patient.in_clinic(@admin)
    @patients = @patients.where(
        "lower(last_name) = ?", params[:patient][:last_name].downcase) unless
        params[:patient][:last_name].empty?
    @patients = @patients.where(
        "lower(first_name) = ?", params[:patient][:first_name].downcase) unless
        params[:patient][:first_name].empty?
    @patients = @patients.where(
        "pid = ?", params[:patient][:pid].downcase) unless
        params[:patient][:pid].empty?
    @patients = @patients.where(
        "dob = ?", Date.parse(params[:patient][:dob].downcase)) unless
        params[:patient][:dob].empty?
  end


  private

    def patient_params
      params.require(:patient).permit(:first_name,
                                      :last_name,
                                      :email,
                                      :password,
                                      :password_confirmation,
                                      :doctor_id,
                                      :phone_number,
                                      :avatar)
    end

  def find_patient
      @patient ||= Patient.find_by_slug!(params[:id])
    end
    helper_method :find_patient

    def find_admin
      @admin ||= Admin.find(params[:admin_id])
    end
    helper_method :find_admin
end