class Clinics::DoctorsController < ApplicationController

  before_filter :poly_authenticate_header

  def index
    @doctors = Clinic.find(params[:clinic_id]).doctors
  end

  def open_times
    if params.has_key? :clinic_id and params.has_key? :date and params.has_key? :doctor_id
      @clinic = Clinic.find(params[:clinic_id])
      date = Date.parse(params[:date])
      doctor = Doctor.find(params[:doctor_id])
      @times = @clinic.open_appointment_times(date, doctor)
      if @times.is_a?(Hash)
        render json: {status: 1, error: @times[:error]}
      else
        render json: { status: 0, times: @times }
      end
    else
      render json: {status: 0, times: []}
    end

  end

end