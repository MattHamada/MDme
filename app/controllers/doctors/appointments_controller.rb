#TODO implement ajax loads
class Doctors::AppointmentsController < ApplicationController

  def index
    @doctor = doctor
    @appointments = Appointment.confirmed_today_with_doctor(@doctor.id)
  end

  def show
    @doctor = doctor
    @appointment = Appointment.find(params[:id])
  end

  private

    def doctor
      @doctor ||= Doctor.find_by_slug!(params[:doctor_id])
    end

    helper_method :doctor
end