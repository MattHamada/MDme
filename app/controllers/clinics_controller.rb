class ClinicsController < ApplicationController

  #TODO move this to API
  def checkin
    patient = Patient.find(params[:patient_id])
    clinic = Clinic.find_by_slug(params[:id])
    patient_appointment = patient.checkin_appointment(clinic)
    unless patient_appointment.nil?
      patient_appointment.update_attribute(:checked_in, true)
      flash[:success] = 'Successfully checked in'
    else
      flash[:danger] = 'No appointment found'
    end
    redirect_to root_path
  end

end
