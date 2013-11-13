class AppointmentsController < ApplicationController

  before_filter :require_admin_login, :only => [:new, :edit, :destroy, :index]

  def new
    @appointment = Appointment.new
  end

  def create
    day = params[:date][:day]
    hour   = params[:date][:hour]
    minute = params[:date][:minute]
    date = DateTime.parse("#{day} #{hour}:#{minute}")
    @appointment = Appointment.new(doctor_id: params[:doctor][:doctor_id],
                                   patient_id: params[:patient][:patient_id],
                                   appointment_time: date,
                                   description: params[:appointment][:description])
    if @appointment.save
      flash[:success] = "Appointment Created"
      redirect_to appointments_path
    else
      flash[:danger] = "Error creating appointment"
      redirect_to new_appointment_url
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


  def destroy
    @appointment = Appointment.find(params[:id])
    @appointment.destroy!
    flash[:notice] = "Appointment deleted"
    redirect_to admins_path
  end

end
