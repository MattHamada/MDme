class Patients::AppointmentsController < ApplicationController

  def index
    @patient = patient
    @appointments = @patient.appointments.
                             confirmed.
                             not_past.
                             includes([:doctor])
  end

  def new
    @patient = patient
  end

  def create
    @patient = patient
    date = DateTime.parse("#{params[:appointment][:date]} #{params[:time]}")
    @appointment = Appointment.new(doctor_id: params[:appointment][:doctor_id],
                                   patient_id: @patient.id,
                                   appointment_time: date,
                                   description: params[:appointment][:description],
                                   request: true,
                                   clinic_id: @patient.clinic_id)
    if @appointment.save
      flash[:success] = "Appointment Requested"
      redirect_to patient_path(@patient)
    else
      @appointment.errors.each do |attribute, message|
        flash[:danger] = message
      end
      redirect_to new_patient_appointment_path(@patient)
    end
  end

  def open_requests
    @patient = patient
    @appointments = @patient.appointments.requests.not_past.includes(:doctor)
  end

  def edit

  end

  def show
    @patient = patient
    @appointment = Appointment.find(params[:id])
    render(partial: 'appointments/ajax_show', object: @appointment) if request.xhr?
  end

  # ajax load when creating new appointment to see open times when given a date
  def open_appointments
    @patient = Patient.find_by_slug(params[:patient_id])
    @date = Date.parse(params[:appointments][:date])
    @doctor = Doctor.find(params[:doctor][:doctor_id])
    @open_times = @doctor.open_appointment_times(@date)
    @appointment = Appointment.new
  end

  private

    def patient
      @patient ||= Patient.find_by_slug!(params[:patient_id])
    end

    helper_method :patient
end