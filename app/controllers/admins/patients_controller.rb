# MDme Rails master application
# Author:: Matt Hamada (maito:mattahamada@gmail.com)
# 3/29/14
# Copyright:: Copyright (c) 2014 MDme
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential.

# <tt>Admins::PatientsController</tt>
# for admin.mdme.us/admins/:admin_id/patients
class Admins::PatientsController < Admins::ApplicationController

  before_filter :find_admin
  before_filter :find_patient, only: [:show, :edit, :update,
                                      :destroy, :registration_form]
  # before_filter :require_admin_login
  # before_action :authenticate_admin_header

  # GET admin.mdme.us/admins/:admin_id/patients
  def index
    @patients = Patient.in_clinic(@admin).ordered_last_name #.includes(:doctor)
    if params.has_key? :patient_search
      @patients = @patients.where("lower(first_name) LIKE ? OR lower(last_name) LIKE ? OR lower(first_name || last_name) LIKE ? OR lower(first_name || ' ' || last_name) LIKE ?",
                                "%#{params[:patient_search]}%".downcase,"%#{params[:patient_search]}%".downcase,"%#{params[:patient_search]}%".downcase, "%#{params[:patient_search]}%".downcase)
    end
    @users = @patients
    if request.xhr?
      render :partial=>'admins/shared/user_list', :layout=>false
    end
  end
  
  def browse
  end

  # GET admin.mdme.us/admins/:admin_id/patients/new
  def new
    @current_user = @admin
    @patient = Patient.new
  end

  # POST admin.mdme.us/admins/:admin_id/patients
  def create
    @current_user = @admin
    p = patient_params
    p[:password] = p[:password_confirmation] = generate_random_password
    p[:doctor_id] = params[:doctors][:doctor_id]
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
    # render partial: 'admins/patients/ajax_show', object: @patient if request.xhr?
  end

  def registration_form
     respond_to do |format|
       format.pdf do
         pdf = PatientRegistrationPdf.new(@patient)
         send_data pdf.render,
                   filename: "#{@patient.last_name}_registration_form.pdf",
                   type: "application/pdf",
                   disposition: "inline"

       end
     end
  end

  # GET admin.mdme.us/admins/:admin_id/patients/:id/edit
  def edit
    @current_user = @admin
  end

  # PATCH admin.mdme.us/admins/:admin_id/patients/:id
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

  # DELETE admin.mdme.us/admins/:admin_id/patients/:id
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
  # GET admin.mdme.us/admins/:admin_id/patients/search
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
                                      :middle_initial,
                                      :name_prefix,
                                      :name_suffix,
                                      :birthday,
                                      :email,
                                      :password,
                                      :password_confirmation,
                                      :doctor_id,
                                      :home_phone,
                                      :work_phone,
                                      :mobile_phone,
                                      :work_phone_extension,
                                      :sex,
                                      :social_security_number,
                                      :marital_status,
                                      :address1,
                                      :address2,
                                      :city,
                                      :state,
                                      :zipcode,
                                      :avatar)
    end

  def find_patient
      if params[:id].match(/\D/)
        @patient = Patient.find_by_slug(params[:id])
      else
        @patient =Patient.find_params[:id]
      end
    end
    helper_method :find_patient

    def   find_admin
      @admin ||= Admin.find(params[:admin_id])
    end
    helper_method :find_admin
end