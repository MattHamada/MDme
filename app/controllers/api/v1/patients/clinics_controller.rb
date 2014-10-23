# MDme Rails master application
# Author:: Matt Hamada (maito:mattahamada@gmail.com)
# 7/28/14
# Copyright:: Copyright (c) 2014 MDme
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential.

# <tt>Api::V1::Patients::ClinicsController</tt> for
# www.mdme.us/api/v1/patients/:patient_id/clinics
# All calls need to pass :api_token for validation
class Api::V1::Patients::ClinicsController < Api::V1::ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :verify_api_token

  # GET www.mdme.us/api/v1/patients/:patient_id/clinics
  def index
    @clinics = @patient.clinics
    @info = "Patient's Clinics"
  end
  def show
    @clinic = Clinic.find(params[:id])
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