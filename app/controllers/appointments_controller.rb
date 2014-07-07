# Author: Matt Hamada
# Copyright MDme 2014
#
# Controller for handling appointments
# Most methods accessed from admin subdomain
#


class AppointmentsController < ApplicationController

  def fill_appointment
    @appointment = Appointment.find(params[:id])
    access_key = params[:access_key]
    if @appointment.access_key != access_key
      redirect_to root_path
    else
      wants_to_fill = params[:fill]
      new_time = params[:new_time]
      if wants_to_fill == 'true'
        @appointment.update_attribute(:appointment_time, DateTime.parse(new_time))
        PatientMailer.appointment_delayed_email(@appointment.patient, DateTime.parse(new_time)).deliver
      else
        Appointment.fill_canceled_appointment(new_time, @appointment.appointment_time)
      end
      redirect_to root_path
    end



  end
end
