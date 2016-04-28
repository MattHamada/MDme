# MDme Rails master application
# Author:: Matt Hamada (maito:mattahamada@gmail.com)
# 3/28/14
# Copyright:: Copyright (c) 2014 MDme
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential.

# <tt>Patients::AppointmentsController</tt>
# for mdme.us/patients/:patient_id/appointments
class Patients::AppointmentsController < ApplicationController

  # before_action :authenticate_header
  before_filter :require_patient_login
  before_filter :find_patient
  before_filter :get_upcoming_appointment, :except=>[:create]

  # GET mdme.us/patients/:patient_id/appointments
  def index
    @appointments = @patient.appointments.
                             confirmed.
                             not_past.
                             includes([:doctors, :clinic]).order_by_time
  end

  # GET mdme.us/patients/:patient_id/appointments/new
  def new
    add_breadcrumb @patient.full_name, patient_path(@patient)
    add_breadcrumb 'Appointments', home_patient_appointments_path(@patient)
    add_breadcrumb 'New Appointment Request'

    if params.has_key? :clinic_id
      @appointment = Appointment.new(appointment_time: DateTime.tomorrow, :clinic_id=>params[:clinic_id])
    else
      @appointment = Appointment.new(appointment_time: DateTime.tomorrow)
    end
    @clinics = @patient.clinics

    @open_times = []
  end

  # POST mdme.us/patients/:patient_id/appointments/:id
  def create
    input = appointment_params
    #used to pass time value not select value#, not sure what changed, so need to calculate time again
    time = input[:time]
    day = Date.strptime(input[:date], '%m/%d/%Y')
    date = Time.zone.parse("#{day.strftime('%F')} #{time}")

    @appointment = Appointment.new(doctor_id: input[:doctor_id],
                                   patient_id: @patient.id,
                                   appointment_time: date,
                                   description: input[:description],
                                   clinic_id: input[:clinic_id],
                                   inform_earlier_time: input[:inform_earlier_time])
    respond_to do |format|
      format.json do
        if @appointment.save
          render status: 201, json: {message: 'Appointment requested'}
        else
          render status: 400, json: {errors: @appointment.errors.full_messages.join(", ")}
        end
      end
      format.js do
        @error = false
        if @appointment.save
        else
          @error = true
          @errors = @appointment.errors.full_messages.join("\n")
        end
      end
    end
  end

  # Shows patient's requests that have not yet been confirmed.
  # GET mdme.us/patients/:patient_id/appointments/open_requests
  def open_requests
    @appointments = @patient.appointments.requests.not_past.includes(:doctors)
  end

  # GET mdme.us/patients/:patient_id/appointments/:id/edit
  def edit
    @appointment = appointment
    @open_times = @appointment.doctor.open_appointment_times(@appointment.appointment_time.to_date)
    @open_times << @appointment.time_selector
    render partial: 'patients/appointments/ajax_edit' if request.xhr?
  end

  # PATCH mdme.us/patients/:patient_id/appointments/:id
  def update
    @appointment = appointment
    input = appointment_params
    time = Time.parse(input[:time])
    hour = time.hour
    minute = time.min
    newtime = @appointment.appointment_time.change({hour: hour, min: minute})
    inform = false
    if input[:inform_earlier_time] == '1'
      inform = true
    end
    if @appointment.update_attributes(description: input[:description],
                                      appointment_time: newtime,
                                      inform_earlier_time: inform)
      flash[:success] = "Request updated"
      redirect_to open_requests_path(@patient)
    else
      flash[:danger] = "Error"
      render edit_patient_appointment_path(@patient, @appointment)
    end
  end

  # will signal to fill the appointment time if the appointment is not a request
  # DELETE mdme.us/patients/:patient_id/appointments/:id
  def destroy
    @appointment = appointment
    unless @appointment.request
      Appointment.fill_canceled_appointment(@appointment.appointment_time, @appointment.appointment_time) if Date.parse(@appointment.date) == Date.today
    end
    if @appointment.destroy
      render status: 200, json: {status: 'Appointment Deleted'}
    else
      render status: 500, json: {}
    end
  end

  # GET mdme.us/patients/:patient_id/appointments/:id
  def show
    @appointment = appointment
    @doctor = Doctor.find(@appointment.doctor.id)
    # render(partial: 'patients/appointments/ajax_show', object: @appointment) if request.xhr?
  end

  def home
    add_breadcrumb @patient.full_name, patient_path(@patient)
    add_breadcrumb 'Appointments'
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
                                          :doctor_full_name,
                                          :inform_earlier_time)
    end

    def set_active_navbar_and_crumbs
      @active = :appointment
      add_breadcrumb 'Home', patients_path
      add_breadcrumb 'Appointments', patient_appointments_path(@patient)
    end
    helper_method :set_active_navbar_and_crumbs

    def load_upcoming_appointment
      @upcoming_appointment = @patient.upcoming_appointment
      get_appointment_progress_bar(@upcoming_appointment) unless @upcoming_appointment.nil?
    end
    helper_method :load_upcoming_appointment

    def find_patient
      @patient ||= current_patient || Patient.includes(:appointments).find_by_slug!(params[:patient_id])
    end
    helper_method :find_patient

    def appointment
      @appointment ||= Appointment.find(params[:id])
    end
    helper_method :appointment
end