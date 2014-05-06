class Doctors::PatientsController < ApplicationController

  before_filter :find_doctor
  before_filter :require_doctor_login

  def index
    @patients = @doctor.patients
  end
  def show
    @patient = Patient.find_by_slug(params[:id])
    render partial: 'doctors/patients/ajax_show' if request.xhr?
  end

  private

  def find_doctor
    @doctor ||= Doctor.find_by_slug!(params[:doctor_id])
  end

  helper_method :find_doctor
end