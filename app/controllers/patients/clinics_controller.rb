class Patients::ClinicsController < ApplicationController
  def getdoctors

    #verify user in slug is logged in
    token_passed = params[:token] unless params[:token].nil?
    patient = Patient.find_by_slug!(params[:patient_id])
    if encrypt(patient.remember_token) != token_passed
      redirect_to signin_path
    else
      allows_cors
      clinic = Clinic.find_by_name(params[:clinic])
      doctors = Doctor.in_passed_clinic_model(clinic)
      docnames = []
      doctors.each { |d| docnames << d.full_name }
      render json: {doctors: docnames}
    end
  end
end
