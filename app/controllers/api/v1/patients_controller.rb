# MDme Rails master application
# Author:: Matt Hamada (maito:mattahamada@gmail.com)
# 4/4/14
# Copyright:: Copyright (c) 2014 MDme
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential.

# <tt>Api::V1::PatientsController</tt> for www.mdme.us/api/v1/patients
# All calls need to pass :api_token for validation
class Api::V1::PatientsController < Api::V1::ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :verify_api_token

  # GET www.mdme.us/api/v1/patients
  def index

    @info = 'Logged in'
    @tasks = [{title: 'Profile'},
              {title: 'Appointments'},
              {title:'My Clinics'},
              {title: 'Sign Out'}]
  end

  # GET www.mdme.us/api/v1/patient/:id
  def show
    @info = 'Profile'
  end

  # POST www.mdme.us/api/v1/patient/:id
  def update
    @patient.bypass_password_validation = true
    if @patient.update_attributes(patient_params)
      render status: 200,
             json: { success: true,
                     info: 'Profile Updated',
                     data: {}}
    else
      render status: 202,
             json: { success: false,
                     info: 'Invalid Parameters',
                     data: @patient.errors.messages}
    end
  end


  private

  def patient_params
    params.require(:patient).permit(:first_name,
                                    :last_name,
                                    :email,
                                    :home_phone,
                                    :mobile_phone,
                                    :work_phone,
                                    :avatar)
  end

  def verify_api_token
    @patient ||= Patient.find_by_api_key(encrypt(params[:api_token]))
    if @patient.nil?
      render status: 401,
             json: { success: false,
                     info: 'Access Denied - Please log in',
                     data: {}}
    end
  end
end
