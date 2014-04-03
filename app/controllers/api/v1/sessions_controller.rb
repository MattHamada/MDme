class Api::V1::SessionsController < ApplicationController
  skip_before_filter :verify_authenticity_token,
                     :if => Proc.new { |c| c.request.format == 'application/json' }
  respond_to :json

  def create
    patient = Patient.find_by(email: params[:patient][:email].downcase)
    if patient && patient.authenticate(params[:patient][:password])
      api_token = api_sign_in patient
      render status: 200,
             json: { success: true,
                     info: 'Logged in',
                     data: { api_token: api_token } }
    else
      render status: 401,
             json: { success: false,
                     info: 'Login failed',
                     data: {}}

    end
  end

  def destroy
    patient = Patient.find_by_remember_token(encrypt(params[:auth_token]))
    if patient
      patient.update_attribute(:remember_token, nil)
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