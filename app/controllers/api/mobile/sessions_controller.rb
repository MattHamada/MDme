class Api::Mobile::SessionsController < Api::Mobile::MobileApplicationController

  def create
    patient = Patient.find_by(email: params[:email].downcase)
    if patient && patient.authenticate(params[:password])
      token = AuthToken.issue_token({user_id: patient.id})
      render json: {
                 user_id: patient.id,
                 api_token: {
                     token: token
                 }
             }
    else
      render json: { error: 'Invalid email/password combination' }, status: :unauthorized
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
