class Patients::ClinicsController < ApplicationController
  #TODO verify user is logged in
  def getdoctors
    clinic = Clinic.find_by_name(params[:clinic])
    doctors = Doctor.in_passed_clinic_model(clinic)
    docnames = []
    doctors.each { |d| docnames << d.full_name }
    render json: {doctors: docnames}
  end
end
