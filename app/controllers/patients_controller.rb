# Author: Matt Hamada
# Copyright MDme 2014
#
# Controller for handling Patient pages on default subdomain (www)
#


class PatientsController < ApplicationController

  #before_filter :find_patient, only: [:show, :edit, :update, :destroy]


  # Currently only administrators can create patients, they cannot sign up on their own.
  before_filter :require_admin_login, :only => [:new, :destroy, :index]
  before_filter :require_admin_or_patient_login, :only => [:edit, :show]
  #before_filter :require_login, :only => [:show]

  def new
    @current_user = current_admin
    @patient = Patient.new
    render 'admins/patient_new'
  end

  def create
    p = patient_params
    p[:password] = p[:password_confirmation] = generate_random_password
    p[:doctor_id] = params[:doctor][:doctor_id]
    @current_user = current_admin
    @patient = Patient.new(p)
    @patient.clinic_id = current_admin.clinic_id
    if @patient.save
      flash[:success] = 'Patient Created'
      redirect_to patients_path
    else
      flash.now[:danger] = 'Error Creating Patient'
      render 'admins/patient_new'
    end
  end

  def show
    @patient = patient
    respond_to do |format|
      format.html do
        render 'admins/patient_show' if request.subdomain == 'admin'

      end # show.html.erb
      format.json  { render :json => @patient, except: [:created_at,
                                                        :updated_at,
                                                        :password_digest,
                                                        :remember_token] }
    end
    #render 'admins/patient_show' if request.subdomain == 'admin'
  end

  # for admin page only
  def index
    @patients = Patient.in_clinic(current_admin).ordered_last_name.includes(:doctor)
    render 'admins/patient_index'
  end

  def edit
    @current_user = patient || current_admin
    @patient = patient

    if request.subdomain == 'admin'
      render 'admins/patient_edit'
    else
      render 'edit'
    end
  end

  def update
    @current_user = patient || current_admin
    @patient = patient

    @patient.is_admin_applying_update = true if request.subdomain == 'admin'

    #skip password validation on update if validated here
    unless @patient.is_admin_applying_update
      if @patient.authenticate(params[:verify][:verify_password])
        @patient.is_admin_applying_update = true
      else
        flash[:danger] = 'Invalid password entered.'
      end
    end

    @patient.attributes = patient_params
    if @patient.save
      flash[:success] = 'Patient Successfully Updated'
      if request.subdomain == 'admin'
        redirect_to patients_path
      else
        redirect_to patient_path(@patient)
      end
    else
      flash.now[:danger] = 'Invalid Parameters Entered'
      if request.subdomain == 'admin'
        render 'admins/patient_edit'
      else
        render 'edit'
      end
    end
  end

  def destroy
    @patient = patient

    @patient.destroy!
    flash[:warning] = 'Patient Deleted'
    redirect_to patients_path
  end

  # def appointments
  #   @patient = patient
  #   @appointments = Appointment.with_patient(@patient.id).confirmed.not_past.
  #                 includes([:doctor])
  # end

  # def appointment_show
  #   @patient = patient
  #   @appointment = Appointment.find(params[:appointment_id])
  #   render(partial: 'ajax_appointment_show', object: @appointment) if request.xhr?
  #
  # end

  def change_password
    @patient = patient

  end

  def update_password
    @patient = patient
    if @patient.authenticate(params[:old_password])
      if @patient.update_attributes(password: params[:new_password],
                                   password_confirmation: params[:new_password_confirm])
        flash[:success] = 'Password updated'
        redirect_to patients_path(@patient)
      else
        flash.now[:danger] = 'Unable to change password'
        render 'change_password'
      end
    else
      flash[:danger] = 'Old password invalid'
      render 'change_password'
    end
  end



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


  private

    def patient
      @patient ||= Patient.find_by_slug!(params[:id])
    end

    helper_method :patient
end
