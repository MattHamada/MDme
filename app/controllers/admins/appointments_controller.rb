class Admins::AppointmentsController < ApplicationController

  before_filter :find_admin
  before_filter :require_admin_login

  def index
    if Appointment.requests.in_clinic(@admin).not_past.any?
      flash.now[:warning] = "Appointments waiting for approval."
    end
  end

  def new
  end

  def edit
    @appointment = appointment
  end

  def update
    @appointment = appointment
    input_params = appointment_params
    date = DateTime.parse("#{input_params[:day]} #{input_params[:hour]}:#{input_params[:minute]}")
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

  #ajax load for open appointments
  def new_browse
    input = appointment_params
    @date = Date.parse(input[:date])
    @doctor = Doctor.find(input[:doctor_id])
    @open_times = @doctor.open_appointment_times(@date)
    @appointment = Appointment.new
  end

  # shows all confirmed appointments on a given date for admin on index page
  def browse
    input = appointment_params
    date = Date.parse(input[:date])
    if date < Date.today
      flash[:danger] = 'Time must be set in the future'
      redirect_to appointments_path
    else
      @appointments = Appointment.in_clinic(@admin).given_date(date).
          confirmed.order('appointment_time ASC').load.includes([:doctor, :patient])
    end
  end

  def create
    input = appointment_params
    date = DateTime.parse("#{input[:date]} #{input[:time]}")
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
      render 'new'
    end
  end

  def approval
    @appointments = Appointment.in_clinic(@admin).requests.
        order_by_time.includes(:doctor, :patient).not_past
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

  # run when admin hits approve or deny on approval page
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

  def show
    @appointment = appointment
    render partial: 'ajax_show' if request.xhr?
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
    redirect_to manage_delays_path(@admin)
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
end