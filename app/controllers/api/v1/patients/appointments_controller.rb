# MDme Rails master application
# Author:: Matt Hamada (maito:mattahamada@gmail.com)
# 4/11/14
# Copyright:: Copyright (c) 2014 MDme
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential.

# <tt>Api::V1::Patients::AppointmentsController</tt> for
# www.mdme.us/api/v1/patients/:patient_id/appointments
# All calls need to pass :api_token for validation
class Api::V1::Patients::AppointmentsController < Api::V1::ApplicationController

  skip_before_filter :verify_authenticity_token
  before_filter :verify_api_token

  # GET www.mdme.us/api/v1/patients/:patient_id/appointments/
  def index
    @tasks = [{title: 'Confirmed Appointments'},
              {title: 'New Request'},
              {title:'Open Requests'}]
  end

  # GET www.mdme.us/api/v1/patients/appointments/:id
  def show
    @appointment = Appointment.find(params[:id])
  end

  # GET www.mdme.us/api/v1/patients/:patient_id/appointments/confirmed_appointments
  def confirmed_appointments
    @appointments = @patient.appointments.
                                confirmed.
                                 not_past.
                                 includes([:doctor])
    if @appointments.empty?
      render json: { success: true,
                     info: 'No upcoming appointments',
                     data: { appointments: [] }
                  }
    end
  end

  # POST www.mdme.us/api/v1/patients/:patient_id/appointments
  def create
    p = appointment_params
    date_time = DateTime.parse(p[:appointment_time])
    p[:appointment_time] = date_time
    @appointment = Appointment.new(p,
                                   request: true)
    if @appointment.save
      render json: { success: true,
                     info: 'Appointment requested',
                     data: {}}
    else
      errors = []
      @appointment.errors.full_messages.each { |e| errors << e}
      render json: { success: false,
                     info: "The following #{@appointment.errors.count} error(s) occured",
                     data: {errors: errors} }
    end
  end

  # POST www.mdme.us/api/v1/patients/:patient_id/appointment/:id
  def update
    p = appointment_params
    date_time = DateTime.parse(p[:appointment_time])
    p[:appointment_time] = date_time
    @appointment = Appointment.find(params[:id])

    if @appointment.update_attributes(p)
      render json: { success: true,
                     info: 'Appointment request updated',
                     data: {}}
    else
      errors = []
      @appointment.errors.full_messages.each { |e| errors << e}
      render json: { success: false,
                     info: "The following #{@appointment.errors.count} error(s) occured",
                     data: {errors: errors} }
    end

  end

  private

    def appointment_params
      params.require(:appointment).permit(:doctor_id,
                                          :patient_id,
                                          :appointment_time,
                                          :clinic_id,
                                          :description)
    end


    def verify_api_token
      @patient ||= Patient.find_by_api_key(encrypt(params[:api_token]));
      if @patient.nil?
        render status: 401,
               json: { success: false,
                       info: 'Access Denied - Please log in',
                       data: {}}
      end
    end
end

