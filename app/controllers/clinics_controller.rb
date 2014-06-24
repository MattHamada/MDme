class ClinicsController < ApplicationController

  #TODO move this to API
  def checkin
    patient = Patient.find(params[:patient_id])
    clinic = Clinic.find_by_slug(params[:id])
    patient_appointment = patient.checkin_appointment(clinic)
    unless patient_appointment.nil?
      patient_appointment.update_attribute(:checked_in, true)
      render status: 200,
             json:  { success: true,
                      info: 'Checked in',
                      data: {}}

    else
      render status: 200,
             json:  { success: false,
                      info: 'No patient found',
                      data: {}}
    end
  end

end
