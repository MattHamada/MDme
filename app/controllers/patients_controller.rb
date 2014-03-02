# Author: Matt Hamada
# Copyright MDme 2014
#
# Controller for handling Patient pages on default subdomain (www)
#


class PatientsController < ApplicationController

  #before_filter :find_patient, only: [:show, :edit, :update, :destroy]


  # Currently only administrators can create patients, they cannot sign up on their own.
  before_filter :require_admin_login, :only => [:new, :destroy, :index]
  before_filter :require_admin_or_patient_login, :only => [:show, :edit]

  def new
    @patient = Patient.new
    render 'admins/patient_new'
  end

  def create
    p = patient_params
    p[:password] = 'temppass'
    p[:password_confirmation] = 'temppass'
    p[:doctor_id] = params[:doctor][:doctor_id]
    @patient = Patient.new(p)
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
      format.html # show.html.erb
      format.json  { render :json => @patient, except: [:created_at,
                                                        :updated_at,
                                                        :password_digest,
                                                        :remember_token] }
    end
  end

  # for admin page only
  def index
    @patients = Patient.all.reorder("last_name").includes(:doctor)
    render 'admins/patient_index'
  end

  def edit
    @patient = patient

    if request.subdomain == 'admin'
      render 'admins/patient_edit'
    else
      render 'edit'
    end
  end

  def update
    @patient = patient

    @patient.is_admin_applying_update = true if request.subdomain == 'admin'
    @patient.attributes = patient_params
    if @patient.save
      flash[:success] = 'Patient Successfully Updated'
      redirect_to patients_path
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



  def patient_params
    params.require(:patient).permit(:first_name, :last_name, :email, :password, :password_confirmation, :doctor_id)
  end


  private

  def patient
    @patient ||= Patient.find_by_slug!(params[:id])
  end

  helper_method :patient
end
