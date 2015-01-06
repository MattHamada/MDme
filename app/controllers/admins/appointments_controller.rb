# MDme Rails master application
# Author:: Matt Hamada (maito:mattahamada@gmail.com)
# 3/2914
# Copyright:: Copyright (c) 2014 MDme
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential.

# <tt>Admins::AppointmentsController</tt>
# for admin.mdme.us/admins/:admin_id/appointments
class Admins::AppointmentsController < ApplicationController

  before_filter :find_admin
  before_filter :require_admin_login
  before_filter :set_active_navbar

  # GET admin.mdme.us/admins/:admin_id/appointments
  def index
    if Appointment.requests.in_clinic(@admin).not_past.any?
      flash.now[:warning] = "Appointments waiting for approval."
    end
    @appointments = Appointment.in_clinic(@admin).today.confirmed.
        order('appointment_time ASC').load.includes([:doctor, :patient])
  end

  # GET admin.mdme.us/admins/:admin_id/appointments/new
  def new
    @appointment = Appointment.new(appointment_time: DateTime.now)
    @clinic_id = @admin.clinic_id
    @open_times = []

  end

  # GET admin.mdme.us/admins/:admin_id/appointments/:id/edit
  def edit
    @appointment = appointment
    @open_times = @appointment.doctor.open_appointment_times(@appointment.appointment_time.to_date)
    @open_times << @appointment.time_selector
  end

  # PATCH admin.mdme.us/admins/:admin_id/appointments/:id/
  def update
    @appointment = appointment
    input_params = appointment_params
    date = DateTime.parse("#{@appointment.date} #{input_params[:time]}")
    if @appointment.update_attributes(doctor_id: input_params[:doctor_id],
                                      patient_id: input_params[:patient_id],
                                      appointment_time: date,
                                      description: input_params[:description])
      flash[:success] = "Appointment was successfully updated."
      redirect_to admins_path
    else
      flash.now[:danger] = "Invalid parameters in update"
      render 'edit'
    end
  end

  # DELETE admin.mdme.us/admins/:admin_id/appointments/:id/
  def destroy
    @appointment = appointment
    if @appointment.destroy
      flash[:warning] = "Appointment deleted"
      redirect_to admin_appointments_path(@admin)
    else
      flash.now[:danger] = "Error processing request"
      admin_appointment_path(@appointment)
    end

  end

  # Ajax load - For open appointments given selected doctor
  # GET admin.mdme.us/admins/:admin_id/appointments/new_browse
  def new_browse
    input = appointment_params
    @date = Date.parse(input[:date])
    @doctor = Doctor.find(input[:doctor_id])
    @open_times = @doctor.open_appointment_times(@date)
    @appointment = Appointment.new
  end

  def browse

  end

  # Ajax load - Shows all confirmed appointments on a given date for  index page
  # Expects the param :day passed as a string date to parse
  # GET admin.mdme.us/admins/:admin_id/appointments/browse
  def ajax_browse
    input = appointment_params
    date = Date.parse(input[:day])
    # if date < Date.today
    #   flash[:danger] = 'Time must be set in the future'
    #   redirect_to admin_appointments_path(@admin)
    # else
      @appointments = Appointment.in_clinic(@admin).given_date(date).
          confirmed.order('appointment_time ASC').load.includes([:doctor,
                                                                 :patient])
    # end
  end

  # POST admin.mdme.us/admins/:admin_id/appointments
  def create
    input = appointment_params
    time = Doctor.find(input[:doctor_id]).open_appointment_times(
        Date.parse(input[:date]))[(input[:time].to_i)-1]
    #TODO make this less hacky; shouldnt need to convert timezone and shift hours
    date = DateTime.parse(
        "#{input[:date]} #{time}").in_time_zone('Arizona') + 7.hours
    @appointment = Appointment.new(doctor_id: input[:doctor_id],
                                   patient_id: input[:patient_id],
                                   appointment_time: date,
                                   description: input[:description],
                                   request: false,
                                   clinic_id: @admin.clinic_id)
    if @appointment.save
      flash[:success] = "Appointment Created"
      redirect_to admin_appointments_path(@admin)
    else
      @appointment.errors.each do |attribute, message|
        flash.now[:danger] = message
      end
      @open_times = []
      render 'new'
    end
  end

  # Shows list of appointments awaiting approval
  # GET admin.mdme.us/admins/:admin_id/appointments/approval
  def approval
    @appointments = Appointment.in_clinic(@admin).requests.
        order_by_time.includes(:doctor, :patient).not_past
  end

  # Allows admin to see what appointments are already on a
  # specific date with a specific doctor before Accepting/denying request
  # GET admin.mdme.us/admins/:admin_id/appointments/show_on_date
  def show_on_date
    @date = Date.parse(params[:date])
    @doctor = Doctor.find(params[:doctor_id]).full_name
    @appointments = Appointment.in_clinic(current_admin).
        given_date(@date).confirmed.with_doctor(params[:doctor_id]).
        order('appointment_time ASC').load
    render(partial: 'ajax_show_on_date', object: @appointments) if request.xhr?
  end

  # run when admin hits approve or deny on approval page
  # POST admin.mdme.us/admins/:admin_id/appointments
  def approve_deny
    appointment = Appointment.find(params[:appointment_id])
    if params.has_key?(:approve)
      appointment.request = false
      appointment.save!
      appointment.email_confirmation_to_patient(:approve)
    elsif params.has_key?(:deny)
      appointment.email_confirmation_to_patient(:deny)
      appointment.destroy
    end
    redirect_to appointment_approval_path(@admin.id)
  end

  # GET admin.mdme.us/admins/:admin_id/appointments/:id
  def show
    @appointment = appointment
    render partial: 'ajax_show' if request.xhr?
  end

  # Shows a list of appointments occurring today for setting delays
  # GET admin.mdme.us/admins/:admin_id/appointments/manage_delays
  def manage_delays
    @doctors = Doctor.in_clinic(current_admin).with_appointments_today
  end

  # POST to add delay to appointment.
  # Can also add delay to subsequent appointments
  # POST admin.mdme.us/admins/:admin_id/appointments/add_delay
  def add_delay
    appointment = Appointment.find(params[:appointment_id])
    time_to_add = Appointment.get_added_time(params[:delay_time].to_i)
    new_time = appointment.appointment_delayed_time + time_to_add.minutes
    if appointment.update_attribute(:appointment_delayed_time, new_time)
      flash[:success] = "Appointments updated"
      appointment.send_delay_email
      appointment.push_delay_notification
    else
      flash[:warning] = "An error has occured please try again."
    end

    if params.values.include?("apply_to_all")
      appointment.update_remaining_appointments!(time_to_add)
    end
    redirect_to manage_delays_path(@admin)
  end

  # POST to notify patient appointment is ready
  # psuhed notification to patients phone
  # POST admin.mdme.us/admins/:admin_id/appointments/notify_ready
  # notify_appointment_ready_path
  # TODO setup some sort of error system if push notfication failed / patient has no device registered to push to.
  def notify_ready
    appointment = Appointment.find(params[:appointment_id])
    flash[:danger] = 'Patient has not checked in' unless appointment.checked_in?
    appointment.push_notify_ready
    redirect_to admin_appointments_path(@admin)
  end





  private

    def appointment_params
      params.require(:appointment).
          permit(:date, :day, :hour, :minute, :time, :doctor_id, :patient_id, :description)
    end

    def find_admin
      @admin ||= Admin.find(params[:admin_id])
    end
    helper_method :find_admin

    def appointment
      @appointment ||= Appointment.find(params[:id])
    end

    def set_active_navbar
      @active = :appointments
    end
end