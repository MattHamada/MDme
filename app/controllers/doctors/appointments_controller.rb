#TODO implement ajax loads
class Doctors::AppointmentsController < ApplicationController

  before_filter :find_doctor
  before_filter :require_doctor_login

  def index
    @appointments = Appointment.confirmed_today_with_doctor(@doctor.id)
  end

  def show
    @appointment = Appointment.find(params[:id])
  end

  private

    def find_doctor
      @doctor ||= Doctor.find_by_slug!(params[:doctor_id])
    end

    helper_method :find_doctor
end