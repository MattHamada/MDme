# MDme Rails master application
# Author:: Matt Hamada (maito:mattahamada@gmail.com)
# 4/23/14
# Copyright:: Copyright (c) 2014 MDme
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential.

# <tt>Patients::ClinicsController</tt>
# for mdme.us/patients/:patient_id/clinics
class Patients::ClinicsController < ApplicationController

  #TODO remove getdoctors exception
  before_action :authenticate_header, except: :getdoctors

  def index
    @clinics = @patient.clinics.ordered_name
  end

  # GET mdme.us/patients/:patient_id/clinics/getdoctors
  # TODO is this method for api?  Should it return a redirect and json?
  def getdoctors
    #verify user in slug is logged in
    token_passed = params[:token] unless params[:token].nil?
    patient = Patient.find_by_slug!(params[:patient_id])
    if my_encrypt(patient.remember_token) != token_passed
      redirect_to signin_path
    else
      allows_cors
      clinic = Clinic.find_by_name(params[:clinic])
      doctors = Doctor.in_clinic(clinic)
      docnames = []
      doctors.each { |d| docnames << d.full_name }
      render json: {doctors: docnames}
    end
  end
end
