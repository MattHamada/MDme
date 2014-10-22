# MDme Rails master application
# Author:: Matt Hamada (maito:mattahamada@gmail.com)
# 3/28/14
# Copyright:: Copyright (c) 2014 MDme
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential.

# <tt>Doctors::AppointmentsController</tt>
# for doctors.mdme.us/doctors/:doctor_id/appointments
class Doctors::AppointmentsController < ApplicationController

  before_filter :find_doctor
  before_filter :require_doctor_login

  # GET doctors.mdme.us/doctors/:doctor_id/appointments
  def index
    @appointments = Appointment.confirmed_today_with_doctor(@doctor.id)
  end

  # GET doctors.mdme.us/doctors/:doctor_id/appointments/:id
  def show
    @appointment = Appointment.find(params[:id])
    render partial: 'doctors/appointments/ajax_show', object: @appointment if request.xhr?
  end

  private

    def find_doctor
      @doctor ||= Doctor.find_by_slug!(params[:doctor_id])
    end

    helper_method :find_doctor
end