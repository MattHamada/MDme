class AppointmentsController < ApplicationController

  before_filter :require_admin_login, :only => [:new, :edit, :destroy, :index]

  def new
    @appointment = Appointment.new
  end

  def create

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
