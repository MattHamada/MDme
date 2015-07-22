class Patients::DoctorsController < ApplicationController

  # before_filter :find_patient
  # before_filter :require_patient_login
  before_filter :authenticate_header

  def show
    @doctor = Doctor.find(params[:id])
    # render partial: 'patients/doctors/ajax_show' if request.xhr?
  end

  def index
    @doctors = Doctor.in_clinic(@patient).includes(:department)
  end

  def open_times
    date = Date.parse(params[:date])
    clinic = Clinic.find(params[:clinic_id])
    doctor = Doctor.find(params[:doctor_id])
    # @times = doctor.open_appointment_times(date)
    @times = clinic.open_appointment_times(date, doctor)
    if @times.is_a?(Hash)
      render json: {status: 1, error: @times[:error]}
    else
      render json: { status: 0, times: @times }
    end
  end

  private

    def find_patient
      @patient ||= Patient.find_by_slug!(params[:patient_id])
    end

    helper_method :find_patient
end