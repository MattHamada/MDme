class Patients::AppointmentsController < ApplicationController

  before_filter :find_patient
  before_filter :require_patient_login

  def index
    @appointments = @patient.appointments.
                             confirmed.
                             not_past.
                             includes([:doctor])
  end

  def new
  end

  def create
    input = appointment_params
    date = DateTime.parse("#{input[:date]} #{input[:time]}")
    @appointment = Appointment.new(doctor_id: input[:doctor_id],
                                   patient_id: @patient.id,
                                   appointment_time: date,
                                   description: input[:description],
                                   request: true,
                                   clinic_id: input[:clinic_id])
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
    @appointments = @patient.appointments.requests.not_past.includes(:doctor)
  end

  def edit
    @appointment = appointment
    @open_times = @appointment.doctor.open_appointment_times(@appointment.appointment_time.to_date)
    @open_times << @appointment.time_selector
    render partial: 'patients/appointments/ajax_edit' if request.xhr?
  end

  def update
    @appointment = appointment
    input = appointment_params
    time = Time.parse(input[:time])
    hour = time.hour
    minute = time.min
    newtime = @appointment.appointment_time.change({hour: hour, min: minute})
    if @appointment.update_attributes(description: input[:description],
                                      appointment_time: newtime)
      flash[:success] = "Request updated"
      redirect_to open_requests_path(@patient)
    else
      flash[:danger] = "Error"
      render edit_patient_appointment_path(@patient, @appointment)
    end
  end

  def destroy
    @appointment = appointment
    if @appointment.destroy
      flash[:success] = "Request deleted"
      redirect_to patient_appointments_path(@patient)
    else
      flash.now[:danger] = "An error has occured"
      render open_requests_path(@patient)
    end
  end

  def show
    @appointment = appointment
    render(partial: 'patients/appointments/ajax_show', object: @appointment) if request.xhr?
  end

  # ajax load when creating new appointment to see open times when given a date
  def open_appointments
    input = appointment_params
    @date = Date.parse(input[:date])
    @doctor = Doctor.find(input[:doctor_id])
    @clinic_id = Clinic.find(input[:clinic_id])
    @open_times = @doctor.open_appointment_times(@date)
    @appointment = Appointment.new
  end

  #mobile
  def menu
    render 'patients/appointments/menu'
  end

  private

    def appointment_params
      params.require(:appointment).permit(:time,
                                          :date,
                                          :doctor_id,
                                          :description,
                                          :clinic_id)
    end

    def find_patient
      @patient ||= Patient.find_by_slug!(params[:patient_id])
    end
    helper_method :find_patient

    def appointment
      @appointment ||= Appointment.find(params[:id])
    end
    helper_method :appointment
end