# Author: Matt Hamada
# Copyright MDme 2014
#
# Controller for handling Patient pages on default subdomain (www)
#


class PatientsController < ApplicationController

  before_filter :find_patient

  before_filter :require_patient_login

  def show
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

  #TODO test the progress bar changes
  def index
    add_breadcrumb 'Home', patients_path
    @appointment = @patient.upcoming_appointment
    unless @appointment.nil?
      minutes_left = ((@appointment.appointment_delayed_time - DateTime.now) / 60).to_i
      case minutes_left
        when 0...5
          @color = 'danger'
          @percent = 90
        when 6...20
          @color = 'warning'
          @percent = 80
        when 21...120
          @color = 'success'
          @percent = 60
        when 121...500
          @percent = 40
          @color = 'success'
        when 501...1440
          @percent = 20
          @color = 'success'
      end
        if minutes_left < 60
          @humanized_time_left = "#{minutes_left} minutes until appointment"
        else
          #TODO have it say hour not hours for 1 hour
          @humanized_time_left = "#{minutes_left / 60} hours and #{minutes_left % 60} minutes left"
        end
    end

  end

  def change_password
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
                                    :phone_number,
                                    :avatar)
  end

    def find_patient
      @patient ||= current_patient || Patient.find_by_slug!(params[:id])
    end

    helper_method :find_patient
end
