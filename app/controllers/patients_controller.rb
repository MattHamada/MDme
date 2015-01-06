# MDme Rails master application
# Author:: Matt Hamada (maito:mattahamada@gmail.com)
# 10/29/13
# Copyright:: Copyright (c) 2014 MDme
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential.

# +PatientsController+ for handling Patient pages on default subdomain (www)
# www.mdme.us/patients
class PatientsController < ApplicationController

  before_filter :find_patient
  before_filter :require_patient_login
  before_filter :get_upcoming_appointment

  # GET www.mdme.us/patients/:id
  def show
    @active = :profile
    add_breadcrumb 'Home', patients_path
    add_breadcrumb 'My Profile', patient_path(@patient)
    respond_to do |format|
      format.html do |variant|
        variant.mobile { render 'patients/mobile/show' }
      end
      format.json  { render :json => @patient, except: [:created_at,
                                                        :updated_at,
                                                        :password_digest,
                                                        :remember_token] }
    end
  end

  # GET www.mdme.us/patients/:id/edit
  def edit
    add_breadcrumb 'Home', patients_path
    add_breadcrumb 'My Profile', patient_path(@patient)
    add_breadcrumb 'Edit Profile', edit_patient_path(@patient)
    @active = :profile
    @current_user = @patient
  end

  # POST www.mdme.us/patients/:id
  def update
    @current_user = @patient
    #skip password validation on update if validated here
    if @patient.authenticate(params[:verify][:verify_password])
      @patient.bypass_password_validation = true
      @patient.attributes = patient_params
      if @patient.save
        flash[:success] = 'Patient Successfully Updated'
        redirect_to patient_path(@patient)
      else
        flash.now[:danger] = 'Invalid parameters entered'
        render 'edit'
      end
    else
      flash[:danger] = 'Invalid password entered'
      render 'edit'
    end

  end

  # GET www.mdme.us/patients
  def index
    @active = :home
    add_breadcrumb 'Home', patients_path
  end

  # GET www.mdme.us/patients/:id/changepassword
  def change_password
    @active = :profile
    add_breadcrumb 'Home', patients_path
    add_breadcrumb 'My Profile', patient_path(@patient)
    add_breadcrumb 'Change Password', patient_password_path(@patient)
  end

  # POST www.mdme.us/patients/:id/updatepassword
  def update_password
    if @patient.authenticate(params[:old_password])
      if @patient.update_attributes(password: params[:new_password],
                                   password_confirmation: params[:new_password_confirm])
        flash[:success] = 'Password updated'
        redirect_to patient_path(@patient)
      else
        flash[:danger] = 'Unable to change password'
        render 'change_password'
      end
    else
      flash[:danger] = 'Old password invalid'
      render 'change_password'
    end
  end

  #mobile stuff below

  def menu
    render 'patients/mobile/menu'
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
                                      :cell_phone,
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
      @patient ||= current_patient || Patient.find_by_slug!(params[:id])
    end
    helper_method :find_patient


    def get_upcoming_appointment
      @upcoming_appointment = @patient.upcoming_appointment
      get_appointment_progress_bar(@upcoming_appointment) unless @upcoming_appointment.nil?
    end


end
