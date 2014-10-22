# MDme Rails master application
# Author:: Matt Hamada (maito:mattahamada@gmail.com)
# 4/22/14
# Copyright:: Copyright (c) 2014 MDme
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential.

# +ClinicsController+ for mdme.us/clinics
class ClinicsController < ApplicationController

  #TODO move this to API
  # GET mdme.us/clinics/:id/checkin/:patient_id'
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
