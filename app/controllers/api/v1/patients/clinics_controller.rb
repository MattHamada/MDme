class Api::V1::Patients::ClinicsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :verify_api_token

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