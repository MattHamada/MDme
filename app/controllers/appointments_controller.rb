# Author: Matt Hamada
# Copyright MDme 2014
#
# Controller for handling appointments
# Most methods accessed from admin subdomain
#


class AppointmentsController < ApplicationController
  #TODO cleanup and reassign permissions to new controllers
  # Only admins can create/edit/destroy/approve appointments
  # Patients can request
  before_filter :require_admin_login, :only => [:new, :edit, :index, :approval]
  before_filter :require_patient_login, :only => [:patient_request]
  before_filter :require_admin_or_patient_login, :only => [:destroy]

  def new
    if request.subdomain =='www'
      @current_user = @current_patient
    else
      @current_user = @current_admin
    end
    @appointment = Appointment.new
  end

  # ajax load when creating new appointment to see open times when given a date on admin site




  # # intial request page where patient enters date and doctor
  # def patient_request
  #   @patient = Patient.find_by_slug(params[:id])
  # end





  #
  # # creates appointments, sets as a request if made from patient site, but not if from admin site.
  # def create
  #   date = DateTime.parse("#{params[:appointment][:date]} #{params[:time]}")
  #
  #   # params slightly different based on if appointment made on patient or admin page
  #   pid = 0
  #   unless params[:appointment][:patient_id].nil?
  #     pid = params[:appointment][:patient_id]
  #   else
  #     pid = params[:patient][:patient_id]
  #   end
  #
  #   #see if admin made an appt or patient requested it
  #   if request.subdomain == 'www'
  #     is_req = true
  #     current_user = current_patient
  #   else
  #     is_req = false
  #     current_user = current_admin
  #   end
  #   @appointment = Appointment.new(doctor_id: params[:appointment][:doctor_id],
  #                                  patient_id: pid,
  #                                  appointment_time: date,
  #                                  description: params[:appointment][:description],
  #                                  request: is_req,
  #                                  clinic_id: current_user.clinic_id)
  #   if @appointment.save
  #     if is_req
  #       req = "Requested"
  #     else
  #       req = "Created"
  #     end
  #     flash[:success] = "Appointment #{req}"
  #     if request.subdomain == 'www'
  #       redirect_to patient_path(Patient.find(params[:appointment][:patient_id]))
  #     else
  #       redirect_to appointments_path
  #     end
  #   else
  #   @appointment.errors.each do |attribute, message|
  #     flash[:danger] = message
  #   end
  #     if request.subdomain == 'www'
  #       redirect_to new_patient_appointment_path(Patient.find(pid))
  #     else
  #       redirect_to new_appointment_url
  #     end
  #   end
  # end

  #patient can view open requests here
  # def edit_requests
  #   @patient = Patient.find_by_slug(params[:id])
  #   @appointments = Appointment.with_patient(@patient.id).not_past.includes(:doctor)
  # end
  #
  # def edit_request
  #   @patient = Patient.find_by_slug(params[:id])
  #   @appointment = Appointment.find(params[:appointment_id])
  #   @open_times = @appointment.doctor.open_appointment_times(@appointment.appointment_time.to_date)
  #   @open_times << @appointment.time_selector
  # end

  # def update_request
  #   @appointment = Appointment.find(params[:appointment_id])
  #   time = Time.parse(params[:time])
  #   hour = time.hour
  #   minute = time.min
  #   newtime = @appointment.appointment_time.change({hour: hour, min: minute})
  #   if @appointment.update_attributes(description: params[:appointment][:description],
  #                                     appointment_time: newtime)
  #     flash[:success] = "Request updated"
  #     redirect_to edit_requests_path
  #   else
  #     flash[:danger] = "Error"
  #     render edit_requests_path
  #   end
  #
  # end


  def edit
    @appointment = Appointment.find(params[:id])
  end

  def update
    @appointment = Appointment.find(params[:id])
    day = params[:date][:day]
    hour   = params[:date][:hour]
    minute = params[:date][:minute]
    date = DateTime.parse("#{day} #{hour}:#{minute}")
    if @appointment.update_attributes(doctor_id: params[:doctor][:doctor_id],
                                      patient_id: params[:patient][:patient_id],
                                      appointment_time: date,
                                      description: params[:appointment][:description])
      flash[:success] = "Appointment was successfully updated."
      redirect_to admins_path
    else
      flash[:danger] = "Invalid parameters in update"
      render 'edit'
    end
  end

  def show
    @appointment = Appointment.find(params[:id])
    render(partial: 'ajax_show', object: @appointment) if request.xhr?
  end



  # accessed from admin page under manage appointments
  # def index
  #   if Appointment.requests.in_clinic(current_admin).not_past.any?
  #     flash.now[:warning] = "Appointments waiting for approval."
  #   end
  # end





  # def destroy
  #   if params.has_key?(:appointment_id)
  #      @appointment = Appointment.find(params[:appointment_id])
  #   else
  #     @appointment = Appointment.find(params[:id])
  #   end
  #   @appointment.destroy!
  #   flash[:warning] = "Appointment deleted"
  #   if request.subdomain == 'admin'
  #     redirect_to admins_path
  #   else
  #     redirect_to edit_requests_path
  #   end
  #
  # end

end
