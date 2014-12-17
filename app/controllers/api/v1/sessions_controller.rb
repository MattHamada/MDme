# MDme Rails master application
# Author:: Matt Hamada (maito:mattahamada@gmail.com)
# 4/2/14
# Copyright:: Copyright (c) 2014 MDme
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential.

# <tt>Api::V1::SessionsController</tt> for www.mdme.us/api/v1/sessions
class Api::V1::SessionsController < Api::V1::ApplicationController
  skip_before_filter :verify_authenticity_token,
                     :if => Proc.new { |c| c.request.format ==
                                       'application/json' }
  respond_to :json

  # POST www.mdme.us/api/v1/sessions/new
  def create
    patient = Patient.find_by(email: params[:patient][:email].downcase)
    if patient && patient.authenticate(params[:patient][:password])
      api_token = api_sign_in patient
      render status: 200,
             json: { success: true,
                     info: 'Logged in',
                     data: { api_token: api_token,
                             id: patient.id }
             }
    else
      render status: 401,
             json: { success: false,
                     info: 'Login failed',
                     data: {}}

    end
  end

  # DELETE www.mdme.us/api/v1/sessions/:id
  def destroy
    patient = Patient.find_by_api_key(my_encrypt(params[:auth_token]))
    if patient
      patient.update_attribute(:api_key, nil)
      sign_out :patient
      render   status: 200,
               json: { success: true,
                       info: 'Logged out',
                       data: {}}
    else
      render status: 401,
             json: { success: false,
                     info: 'API token invalid',
                     data: {}}

    end
  end
end
