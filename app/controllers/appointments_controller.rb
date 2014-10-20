#MDme Rails master application
# Author:: Matt Hamada (maito:mattahamada@gmail.com)
# Copyright:: Copyright (c) 2014 MDme


# +AppointmentsController+ for handling appointments
class AppointmentsController < ApplicationController

  # Called when a patient accepts notice by email that they can take earlier
  # appointment time slot.  Uses access key in url in email to verify that
  # the appointment being moved up is the one specified in the email.
  # If the patient denys taking earlier time, a new mailer is sent to the next
  # available patient
  def fill_appointment
    @appointment = Appointment.find(params[:id])
    access_key = params[:access_key]
    if @appointment.access_key != access_key
      redirect_to root_path
    else
      wants_to_fill = params[:fill]
      new_time = params[:new_time]
      if wants_to_fill == 'true'
        @appointment.update_attribute(
            :appointment_time, DateTime.parse(new_time))
        #TODO make dedicated email for filling opening instead of using delayed email
        PatientMailer.appointment_delayed_email(
            @appointment.patient, DateTime.parse(new_time)).deliver
      else
        Appointment.fill_canceled_appointment(
            new_time, @appointment.appointment_time)
      end
      redirect_to root_path
    end
  end
end
