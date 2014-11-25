# MDme Rails master application
# Author:: Matt Hamada (maito:mattahamada@gmail.com)
# 4/11/14
# Copyright:: Copyright (c) 2014 MDme
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential.

# <tt>Api::V1::Patients::DoctorsController</tt> for
# www.mdme.us/api/v1/patients/:patient_id/doctors
# All calls need to pass :api_token for validation
class Api::V1::Patients::DoctorsController < Api::V1::ApplicationController
  #TODO probably need to make doctors a subsection of clinics and not patients. ASK andrew

  skip_before_filter :verify_authenticity_token
  before_filter :verify_api_token

  #GET www.mdme.us/api/v1/patients/:patient_id/doctors
  def index
    clinic =  @patient.clinics.where(name: params[:name]).first
    @department = clinic.departments.where(name: params[:name])
    @doctors = Doctor.in_department(@department)
  end

  #GET www.mdme.us/api/v1/patients/:patient_id/doctor/:id
  def show
    @doctor = Doctor.find(params[:id])
    rescue
      render  status: 202,
              json: { success: false,
                      info: 'Doctor not found.',
                      data: {}}
  end

  private
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