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

  def show
    @patient = patient
    respond_to do |format|
      format.html
      format.json  { render :json => @patient, except: [:created_at,
                                                        :updated_at,
                                                        :password_digest,
                                                        :remember_token] }
    end
  end

  def edit
    @patient = @current_user = patient
  end

  def update
    @current_user = patient || current_admin
    @patient = patient
    #skip password validation on update if validated here
    if @patient.authenticate(params[:verify][:verify_password])
      @patient.is_admin_applying_update = true
    else
      flash[:danger] = 'Invalid password entered.'
      #TODO redirect flow to end here if password invalid
    end
    @patient.attributes = patient_params
    if @patient.save
      flash[:success] = 'Patient Successfully Updated'
      redirect_to patient_path(@patient)
    else
      flash.now[:danger] = 'Invalid Parameters Entered'
        render 'edit'
    end
  end

  def destroy
    @patient = patient

    @patient.destroy!
    flash[:warning] = 'Patient Deleted'
    redirect_to patients_path
  end

  def change_password
    @patient = patient
  end

  def update_password
    @patient = patient
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
