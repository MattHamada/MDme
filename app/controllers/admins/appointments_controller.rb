class Admins::AppointmentsController < ApplicationController

  def index
    @admin = admin
    if Appointment.requests.in_clinic(@admin).not_past.any?
      flash.now[:warning] = "Appointments waiting for approval."
    end
  end

  def new
    @admin = admin
  end

  def edit
    @admin = admin
    @appointment = appointment
  end

  def update
    @admin = admin
    @appointment = appointment
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
      flash.now[:danger] = "Invalid parameters in update"
      render 'edit'
    end
  end

  def destroy
    @admin = admin
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
    @admin = admin
    @date = Date.parse(params[:appointments][:date])
    @doctor = Doctor.find(params[:doctor][:doctor_id])
    @open_times = @doctor.open_appointment_times(@date)
    @appointment = Appointment.new
  end

  # shows all confirmed appointments on a given date for admin on index page
  def browse
    @admin = admin
    date = Date.parse(params[:appointments][:date])
    if date < Date.today
      flash[:danger] = 'Time must be set in the future'
      redirect_to appointments_path
    else
      @appointments = Appointment.in_clinic(@admin).given_date(date).
          confirmed.order('appointment_time ASC').load
    end
  end

  def create
    @admin = admin
    date = DateTime.parse("#{params[:appointment][:date]} #{params[:time]}")
    # params slightly different based on if appointment made on patient or admin page
    pid = params[:patient][:patient_id]

    @appointment = Appointment.new(doctor_id: params[:appointment][:doctor_id],
                                   patient_id: pid,
                                   appointment_time: date,
                                   description: params[:appointment][:description],
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
    @admin = admin
    @appointments = Appointment.in_clinic(@admin).requests.
        order_by_time.includes(:doctor, :patient).not_past
  end

  # allows admin to see what appointments are already on a specific date with a specific
  # doctor before Accepting/denying request
  def show_on_date
    @admin = admin
    @date = Date.parse(params[:date])
    @doctor = Doctor.find(params[:doctor_id]).full_name
    @appointments = Appointment.in_clinic(current_admin).
        given_date(@date).confirmed.with_doctor(params[:doctor_id]).
        order('appointment_time ASC').load
    render(partial: 'ajax_show_on_date', object: @appointments) if request.xhr?
  end

  # run when admin hits approve or deny on approval page
  def approve_deny
    @admin = admin
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
    @admin = admin
    @appointment = appointment
    render partial: 'ajax_show' if request.xhr?
  end

  def manage_delays
    @admin = admin
    @doctors = Doctor.in_clinic(current_admin).with_appointments_today
  end

  def add_delay
    @admin = admin
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
    def admin
      @admin ||= Admin.find(params[:admin_id])
    end
    helper_method :admin

    def appointment
      @appointment ||= Appointment.find(params[:id])
    end
end