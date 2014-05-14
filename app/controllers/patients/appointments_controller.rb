class Patients::AppointmentsController < ApplicationController

  before_filter :find_patient, except: [:open_appointments]
  before_filter :require_patient_login
  before_filter :set_active_navbar_and_crumbs

  def index
    @appointments = @patient.appointments.
                             confirmed.
                             not_past.
                             includes([:doctor, :clinic])
  end

  def new
    add_breadcrumb 'New Appointment', new_patient_appointment_path(@patient)

    @appointment = Appointment.new(appointment_time: DateTime.tomorrow)
    @open_times = []
  end

  def create
    input = appointment_params
    #used to pass time value not select value#, not sure what changed, so need to calculate time again
    time = Doctor.find(input[:doctor_id]).open_appointment_times(Date.parse(input[:date]))[(input[:time].to_i)-1]
    date = DateTime.parse("#{input[:date]} #{time}")

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
    # input = appointment_params
    # @date = Date.parse(input[:date])
    # @clinic_id = Clinic.find_by_name(input[:clinic_name]).id
    # @doctor = Doctor.find_by_full_name(input[:doctor_full_name], @clinic_id)
    # @open_times = @doctor.open_appointment_times(@date)
    # #@appointment = Appointment.new
    # render json: {open_times: @open_times}
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
                                          :clinic_id,
                                          :clinic_name,
                                          :doctor_full_name)
    end

    def set_active_navbar_and_crumbs
      @active = :appointment
      add_breadcrumb 'Home', patients_path
      add_breadcrumb 'Appointments', patient_appointments_path(@patient)
    end
    helper_method :set_active_navbar

    def find_patient
      @patient ||= current_patient || Patient.find_by_slug!(params[:patient_id])
    end
    helper_method :find_patient

    def appointment
      @appointment ||= Appointment.find(params[:id])
    end
    helper_method :appointment
end