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
    @patient = patient
    @appointment = appointment
    @open_times = @appointment.doctor.open_appointment_times(@appointment.appointment_time.to_date)
    @open_times << @appointment.time_selector
  end

  def update
    @patient = patient
    @appointment = appointment
    time = Time.parse(params[:time])
    hour = time.hour
    minute = time.min
    newtime = @appointment.appointment_time.change({hour: hour, min: minute})
    if @appointment.update_attributes(description: params[:appointment][:description],
                                      appointment_time: newtime)
      flash[:success] = "Request updated"
      redirect_to open_requests_path(@patient)
    else
      flash[:danger] = "Error"
      render edit_patient_appointment_path(@patient, @appointment)
    end
  end

  def destroy
    @patient = patient
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
    @patient = patient
    @appointment = appointment
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

    def appointment
      @appointment ||= Appointment.find(params[:id])
    end
    helper_method :appointment
end