class Patients::DoctorsController < ApplicationController

  before_filter :find_patient
  before_filter :require_patient_login

  def show
    @doctor = Doctor.find_by_slug(params[:id])
  end

  def index
    @doctors = Doctor.in_clinic(@patient).includes(:department)
  end

  private

    def find_patient
      @patient ||= Patient.find_by_slug!(params[:patient_id])
    end

    helper_method :find_patient
end