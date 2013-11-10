class AppointmentsController < ApplicationController

  before_filter :require_admin_login, :only => [:new, :edit, :destroy, :index]

  def new
    @appointment = Appointment.new
  end

  def create
    year   = params[:date][:year].to_i
    month  = params[:date][:month].to_i
    day    = params[:date][:day].to_i
    hour   = params[:date][:hour].to_i
    minute = params[:date][:minute].to_i
    date = DateTime.new(year, month, day, hour, minute)
    @appointment = Appointment.new(doctor_id: params[:doctor][:doctor_id],
                                   patient_id: params[:patient][:patient_id],
                                   appointment_time: date,
                                   description: params[:appointment][:description])
    if @appointment.save
      flash[:success] = "Appointment created"
      redirect_to appointments_path
    else
      flash[:danger] = "Error creating appointment"
      redirect_to new_appointment_url
    end
  end


  def edit

  end

  def index

  end

  def browse
    year  = params[:date][:year].to_i
    month = params[:date][:month].to_i
    day   = params[:date][:day].to_i
    date = Date.new(year, month, day)
    @appointments = Appointment.given_date(date).order('appointment_time ASC').load

  end


  def destroy

  end

end
