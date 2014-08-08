class Api::V1::Patients::AppointmentsController < ApplicationController

  skip_before_filter :verify_authenticity_token
  before_filter :verify_api_token

  def tasks
    @tasks = [{title: 'Confirmed Appointments'},
              {title: 'New Request'},
              {title:'Open Requests'}]
  end

  def show

  end

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

