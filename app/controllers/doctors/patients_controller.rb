class Doctors::PatientsController < ApplicationController

  def index
    @doctor = doctor
    @patients = @doctor.patients
  end
  #TODO implement ajax load
  def show
    @doctor = doctor
    @patient = Patient.find_by_slug(params[:id])
  end

  private

  def doctor
    @doctor ||= Doctor.find_by_slug!(params[:doctor_id])
  end

  helper_method :doctor
end