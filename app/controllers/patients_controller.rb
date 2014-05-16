# Author: Matt Hamada
# Copyright MDme 2014
#
# Controller for handling Patient pages on default subdomain (www)
#


class PatientsController < ApplicationController

  before_filter :find_patient

  before_filter :require_patient_login
  before_filter :get_upcoming_appointment

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

  def edit
    add_breadcrumb 'Home', patients_path
    add_breadcrumb 'My Profile', patient_path(@patient)
    add_breadcrumb 'Edit Profile', edit_patient_path(@patient)
    @active = :profile
    @current_user = @patient
  end

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
        flash.now[:danger] = 'Invalid Parameters Entered'
        render 'edit'
      end
    else
      flash[:danger] = 'Invalid password entered.'
      render 'edit'
    end

  end

  def index
    @active = :home
    add_breadcrumb 'Home', patients_path
  end

  def change_password
    @active = :profile
    add_breadcrumb 'Home', patients_path
    add_breadcrumb 'My Profile', patient_path(@patient)
    add_breadcrumb 'Change Password', patient_password_path(@patient)
  end

  def update_password
    if @patient.authenticate(params[:old_password])
      if @patient.update_attributes(password: params[:new_password],
                                   password_confirmation: params[:new_password_confirm])
        flash[:success] = 'Password updated'
        redirect_to patient_path(@patient)
      else
        flash.now[:danger] = 'Unable to change password'
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
                                    :email,
                                    :password,
                                    :password_confirmation,
                                    :doctor_id,
                                    :home_phone,
                                    :work_phone,
                                    :avatar)
  end

    def find_patient
      @patient ||= current_patient || Patient.find_by_slug!(params[:id])
    end
    helper_method :find_patient

  #TODO make out of 2 hours, progress more times

    def get_upcoming_appointment
      @upcoming_appointment = @patient.upcoming_appointment
      get_appointment_progress_bar(@upcoming_appointment) unless @upcoming_appointment.nil?
    end


end
