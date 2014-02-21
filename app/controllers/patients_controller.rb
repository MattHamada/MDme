# Author: Matt Hamada
# Copyright MDme 2014
#
# Controller for handling Patient pages on default subdomain (www)
#


class PatientsController < ApplicationController

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
    @patient = Patient.find(params[:id])
  end

  # for admin page only
  def index
    @patients = Patient.all.reorder("last_name")
    render 'admins/patient_index'
  end

  def edit
    @patient = Patient.find(params[:id])
    if request.subdomain == 'admin'
      render 'admins/patient_edit'
    else
      render 'edit'
    end
  end

  def update
    @patient = Patient.find(params[:id])
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
    @patient = Patient.find(params[:id])
    @patient.destroy!
    flash[:warning] = 'Patient Deleted'
    redirect_to patients_path
  end



  def patient_params
    params.require(:patient).permit(:first_name, :last_name, :email, :password, :password_confirmation, :doctor_id)
  end
end
