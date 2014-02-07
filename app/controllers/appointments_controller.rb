class AppointmentsController < ApplicationController

  before_filter :require_admin_login, :only => [:new, :edit, :destroy, :index]
  before_filter :require_patient_login, :only => [:patient_request]

  def new
    @appointment = Appointment.new
  end

  def new_request
    @appointment = Appointment.new
    time = params[:time]
    date = Time.parse(params[:date] + " " + params[:time])
    @appointment.appointment_time = date
    @appointment.patient_id = params[:id]
    @appointment.doctor_id = params[:doctor]


  end

  def create
    date = DateTime.parse("#{params[:appointment][:date]} #{params[:appointment][:time]}")
    if !params[:appointment].has_key?(:doctor_id) || !params[:appointment].has_key?(:patient_id)
      flash[:danger] = "Error creating appointment"
      redirect_to new_appointment_url
    else
      @appointment = Appointment.new(doctor_id: params[:appointment][:doctor_id],
                                     patient_id: params[:appointment][:patient_id],
                                     appointment_time: date,
                                     description: params[:appointment][:description],
                                     request: params[:appointment][:request].to_bool)
      if @appointment.save
        if params[:appointment][:request].to_bool
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
      #flash[:danger] = "Error Encountered"
      @appointment.errors.each do |attribute, message|
        flash[:danger] = message
      end
        if request.subdomain == 'www'
          redirect_to request_appointment_path(Patient.find(params[:appointment][:patient_id]))
        else
          redirect_to new_appointment_url
        end
      end
    end

  #  day = params[:date][:day]
  #  hour   = params[:date][:hour]
  #  minute = params[:date][:minute]
  #  date = DateTime.parse("#{day} #{hour}:#{minute}")
  #
  #  if !params.has_key?(:doctor_id) || !params.has_key?(:patient_id)
  #    flash[:danger] = "Error creating appointment"
  #    redirect_to new_appointment_url
  #  else
  #
  #
  #    @appointment = Appointment.new(doctor_id: params[:doctor][:doctor_id],
  #                                   patient_id: params[:patient][:patient_id],
  #                                   appointment_time: date,
  #                                   description: params[:appointment][:description])
  #    if @appointment.save
  #      flash[:success] = "Appointment Created"
  #      redirect_to appointments_path
  #    else
  #      flash[:danger] = "Error creating appointment"
  #      redirect_to new_appointment_url
  #    end
  #  end
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

  def index

  end

  def browse
    date = Date.parse(params[:appointments][:date])
    @appointments = Appointment.given_date(date).order('appointment_time ASC').load

  end

  def patient_request
    @patient = Patient.find(params[:id])
  end

  def open_appointments
    @patient = Patient.find(params[:id])
    @date = Date.parse(params[:appointments][:date])
    @doctor = Doctor.find(params[:doctor][:doctor_id])
    @open_times = @doctor.open_appointment_times(@date)
    @appointment = Appointment.new

  end


  def destroy
    @appointment = Appointment.find(params[:id])
    @appointment.destroy!
    flash[:warning] = "Appointment deleted"
    redirect_to admins_path
  end

end
