# MDme Rails master application
# Author:: Matt Hamada (maito:mattahamada@gmail.com)
# 7/27/15
# Copyright:: Copyright (c) 2015 Dynamic Medicine, LLC
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential.
class Api::Mobile::PatientsController < Api::Mobile::MobileApplicationController

  before_action :authenticate_header

  def show
  end

  def get_upcoming_appointment
    upcoming_appointment = @patient.upcoming_appointment
    if upcoming_appointment
      render json:  get_appointment_progress_bar(upcoming_appointment).to_json
    else
      render json: {}
    end
  end

  #TODO gives render error with no appointment, figure what to do with no appt on mobile end
  def upcoming_appointment_qrcode
    @patient = Patient.first
    upcoming_appointment = @patient.upcoming_appointment
    if upcoming_appointment
      url = "https://www.mdme.us/clinics/#{upcoming_appointment.checkin_key}/checkin"
      @qrcode = RQRCode::QRCode.new(url)
      respond_to do |format|
        format.png { send_data @qrcode.as_png(color: '#0097A7'), disposition: 'inline' }
      end
    end
  end


  private
    #TODO might belong in appointment model
    def get_appointment_progress_bar(upcoming_appointment)
      results = {
          id:   upcoming_appointment.id,
          clinic_address: upcoming_appointment.clinic_mail_address,
          doctor: upcoming_appointment.doctor_full_name,
          date: upcoming_appointment.date,
          time: upcoming_appointment.delayed_time_ampm
      }
      minutes_left =
          ((upcoming_appointment.appointment_delayed_time - DateTime.now) / 60).to_i
      results[:minutesLeft] = minutes_left
      results[:percent] = 100-minutes_left
      results
    end
end
