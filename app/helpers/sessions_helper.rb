module SessionsHelper
  def sign_in(patient)
    remember_token = Patient.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    patient.update_attribute(:remember_token, Patient.encrypt(remember_token))
    self.current_patient = patient
  end

  def sign_out
    cookies.delete(:remember_token)
    self.current_patient = nil
  end

  def current_patient=(patient)
    @current_patient = patient
  end

  def current_patient
    remember_token = Patient.encrypt(cookies[:remember_token])
    @current_patient ||= Patient.find_by(remember_token: remember_token)
  end

  def signed_in?
    !current_patient.nil?
  end
end
