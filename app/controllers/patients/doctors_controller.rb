class Patients::DoctorsController < ApplicationController

  def show
    @patient = patient
    @doctor = Doctor.find_by_slug(params[:id])
  end

  def index
    @patient = patient
    @doctors = Doctor.in_clinic(@patient).includes(:department)
  end

  private

    def patient
      @patient ||= Patient.find_by_slug!(params[:patient_id])
    end

    helper_method :patient
end