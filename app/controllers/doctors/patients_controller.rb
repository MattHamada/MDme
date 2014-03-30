class Doctors::PatientsController < ApplicationController

  before_filter :find_doctor
  before_filter :require_doctor_login

  def index
    @patients = @doctor.patients
  end
  #TODO implement ajax load
  def show
    @patient = Patient.find_by_slug(params[:id])
  end

  private

  def find_doctor
    @doctor ||= Doctor.find_by_slug!(params[:doctor_id])
  end

  helper_method :find_doctor
end