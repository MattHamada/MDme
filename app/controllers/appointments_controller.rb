# Author: Matt Hamada
# Copyright MDme 2014
#
# Controller for handling appointments
# Most methods accessed from admin subdomain
#


class AppointmentsController < ApplicationController

  # Only admins can create/edit/destroy/approve appointments
  # Patients can request
  #TODO Allow patients to edit appointments before they are confirmed
  before_filter :require_admin_login, :only => [:new, :edit, :destroy, :index, :approval]
  before_filter :require_patient_login, :only => [:patient_request]

  def new
    #TODO Load only open times on admin page similar to patient page
    if request.subdomain =='www'
      @current_user = @current_patient
    else
      @current_user = @current_admin
    end
    @appointment = Appointment.new
  end

  # ajax load when creating new appointment to see open times when given a date on admin site
  def admin_new_browse
    @date = Date.parse(params[:appointments][:date])
    @doctor = Doctor.find(params[:doctor][:doctor_id])
    @open_times = @doctor.open_appointment_times(@date)
    @appointment = Appointment.new
  end




  # intial request page where patient enters date and doctor
  def patient_request
    @patient = Patient.find_by_slug(params[:id])
  end

  # ajax load when creating new appointment to see open times when given a date
  def open_appointments
    @patient = Patient.find_by_slug(params[:id])
    @date = Date.parse(params[:appointments][:date])
    @doctor = Doctor.find(params[:doctor][:doctor_id])
    @open_times = @doctor.open_appointment_times(@date)
    @appointment = Appointment.new

  end

  def approve_deny
    appointment = Appointment.find(params[:appointment_id]) unless params[:appointment_id].nil?
    if params.has_key?(:approve)
      appointment.request = false
      appointment.save!
      appointment.email_confirmation_to_patient(:approve)
    elsif params.has_key?(:deny)
      appointment.email_confirmation_to_patient(:deny)
      appointment.destroy
    end
    redirect_to appointment_approval_path
  end

  # run when admin hits approve or deny on approval page
  def approval
    @appointments = Appointment.in_clinic(current_admin).requests.
                      order_by_time.includes(:doctor, :patient).not_past
    # if params.has_key?(:approve)
    #   appointment =  Appointment.find(params[:appointment_id])
    #   appointment.request = false
    #   appointment.save!
    #   appointment.patient.email_confirmation_to_patient(appointment, :approve)
    # elsif params.has_key?(:deny)
    #   appointment =  Appointment.find(params[:appointment_id])
    #   appointment.patient.email_confirmation_to_patient(appointment, :deny)
    #   Appointment.delete(params[:appointment_id])
    # end
    # @appointments = Appointment.in_clinic(current_admin).requests.
    #     order_by_time.includes(:doctor, :patient).not_past

  end

  # creates appointments, sets as a request if made from patient site, but not if from admin site.
  def create
    date = DateTime.parse("#{params[:appointment][:date]} #{params[:time]}")

    # params slightly different based on if appointment made on patient or admin page
    pid = 0
    unless params[:appointment][:patient_id].nil?
      pid = params[:appointment][:patient_id]
    else
      pid = params[:patient][:patient_id]
    end

    #see if admin made an appt or patient requested it
    if request.subdomain == 'www'
      is_req = true
      current_user = current_patient
    else
      is_req = false
      current_user = current_admin
    end
    @appointment = Appointment.new(doctor_id: params[:appointment][:doctor_id],
                                   patient_id: pid,
                                   appointment_time: date,
                                   description: params[:appointment][:description],
                                   request: is_req,
                                   clinic_id: current_user.clinic_id)
    if @appointment.save
      if is_req
        req = "Requested"
      else
        req = "Created"
      end
      flash[:success] = "Appointment #{req}"
      if request.subdomain == 'www'
        redirect_to patient_path(Patient.find(params[:appointment][:patient_id]))
      else
        redirect_to appointments_path
      end
    else
    @appointment.errors.each do |attribute, message|
      flash[:danger] = message
    end
      if request.subdomain == 'www'
        redirect_to request_appointment_path(Patient.find(pid))
      else
        redirect_to new_appointment_url
      end
    end
  end


  def edit
    @appointment = Appointment.find(params[:id])
  end

  def update
    @appointment = Appointment.find(params[:id])
    day = params[:date][:day]
    hour   = params[:date][:hour]
    minute = params[:date][:minute]
    date = DateTime.parse("#{day} #{hour}:#{minute}")
    if @appointment.update_attributes(doctor_id: params[:doctor][:doctor_id],
                                      patient_id: params[:patient][:patient_id],
                                      appointment_time: date,
                                      description: params[:appointment][:description])
      flash[:success] = "Appointment was successfully updated."
      redirect_to admins_path
    else
      flash[:danger] = "Invalid parameters in update"
      render 'edit'
    end
  end

  def show
    @appointment = Appointment.find(params[:id])
    render(partial: 'ajax_show', object: @appointment) if request.xhr?
  end

  # allows admin to see what appointments are already on a specific date with a specific
  # doctor before Accepting/denying request
  def show_on_date
    @date = Date.parse(params[:date])
    @doctor = Doctor.find(params[:doctor_id]).full_name
    @appointments = Appointment.in_clinic(current_admin).
        given_date(@date).confirmed.with_doctor(params[:doctor_id]).
        order('appointment_time ASC').load
    render(partial: 'ajax_show_on_date', object: @appointments) if request.xhr?
  end

  # accessed from admin page under manage appointments
  def index
    if Appointment.requests.in_clinic(current_admin).not_past.any?
      flash.now[:warning] = "Appointments waiting for approval."
    end
  end

  # shows all confirmed appointments on a given date for admin
  def browse
    date = Date.parse(params[:appointments][:date])
    if date < Date.today
      flash[:danger] = 'Time must be set in the future'
      redirect_to appointments_path
    else
      @appointments = Appointment.in_clinic(current_admin).given_date(date).
          confirmed.order('appointment_time ASC').load

    end

  end

  def manage_delays
    @doctors = Doctor.in_clinic(current_admin).with_appointments_today
  end

  def add_delay
    appointment = Appointment.find(params[:appointment_id])
    time_to_add = Appointment.get_added_time(params[:delay_time].to_i)
    new_time = appointment.appointment_delayed_time + time_to_add.minutes
    if appointment.update_attribute(:appointment_delayed_time, new_time)
      flash[:success] = "Appointments updated"
      appointment.send_delay_email
    else
      flash[:warning] = "An error has occured please try again."
    end

    if params.values.include?("apply_to_all")
      appointment.update_remaining_appointments!(time_to_add)
    end

    redirect_to manage_delays_path
  end

  def destroy
    @appointment = Appointment.find(params[:id])
    @appointment.destroy!
    flash[:warning] = "Appointment deleted"
    redirect_to admins_path
  end

end
