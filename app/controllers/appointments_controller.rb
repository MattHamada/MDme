# MDme Rails master application
# Author:: Matt Hamada (maito:mattahamada@gmail.com)
# 11/4/13
# Copyright:: Copyright (c) 2014 MDme
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential.


# +AppointmentsController+ for for mdme.us/appointments
class AppointmentsController < ApplicationController

  # Called when a patient accepts notice by email that they can take earlier
  # appointment time slot.  Uses access key in url in email to verify that
  # the appointment being moved up is the one specified in the email.
  # If the patient denys taking earlier time, a new mailer is sent to the next
  # available patient
  # GET mdme.us/appointments/:id/fill_appointment

  # TODO add safeguard so you cannot alter url to change appointment time
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
        #TODO strftime should be in mailer method but gave serialization error, dirty here
        PatientMailer.appointment_update_time_email(
            @appointment.patient, DateTime.parse(new_time)).deliver_later
      else
        Appointment.fill_canceled_appointment(
            new_time, @appointment.appointment_time)
      end
      redirect_to root_path
    end
  end

  # Called when QR code from patient's phone scanned by clinic
  # will appointment as being checked in
  # POST admin.mdme.us/appointments/check-in?checkin_key=x
  def check_in_patient
    p = appointment_params
    @appointment = Appointment.find_by_checkin_key(p[:checkin_key])
    if @appointment.nil?
      render status: 404, json: {
                            success: false,
                            message: 'Invalid checkin key'
                        }
    else
      if @appointment.update_attribute(:checked_in, true)
        render status: :accepted, json: {
                                    success: true,
                                    message: 'Patient checked in'
                                }
      end

    end
  end

  private
    def appointment_params
      params.require(:appointment).permit(:checkin_key)
    end
end
