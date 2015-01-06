class Api::V2::SessionsController < ApplicationController
  skip_before_filter :verify_authenticity_token,
                     :if => Proc.new { |c| c.request.format == 'application/json' }



  def create
    patient = Patient.find_by(email: params[:patient][:email].downcase)
    if patient && patient.authenticate(params[:patient][:password])
      token = api_sign_in patient
      render json: {api_token: token},
             callback: params[:callback]
    else

      render  :json => {:denied => "invalid_login"}, :callback => params[:callback]

    end
  end

  def api_login
    @patient = Patient.find_by(api_key: params[:token])
    if @patient
      sign_in @patient, :patient
      render json:{url: patient_mobile_menu_url(@patient) }
    end
  end

  def get_token
    @patient = current_patient
    if @patient
      render json: {token: @patient.api_key}
    end
  end

  def destroy
    patient = Patient.find_by_api_key(my_encrypt(params[:auth_token]))
    if patient
      patient.update_attribute(:api_key, nil)
      sign_out :patient
      render   status: 200,
               json: { success: true,
                       info: 'Logged out',
                       data: {}},
               callback: params[:callback]
    else
      render status: 401,
             json: { success: false,
                     info: 'API token invalid',
                     data: {}},
             callback: params[:callback]
    end
  end
end
