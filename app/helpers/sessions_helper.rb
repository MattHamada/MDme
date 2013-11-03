module SessionsHelper
  def sign_in(user, type)
    if type == :patient
    remember_token = Patient.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_token, Patient.encrypt(remember_token))
    self.current_patient = user

    elsif type == :doctor
      remember_token = Patient.new_remember_token
      cookies.permanent[:remember_token] = remember_token
      user.update_attribute(:remember_token, Patient.encrypt(remember_token))
      self.current_doctor = user
    end
  end

  def sign_out(type)
    cookies.delete(:remember_token)
    if type == :patient
      self.current_patient = nil
    elsif type == :doctor
      self.current_doctor = nil
    end
  end

  def current_patient=(patient)
    @current_patient = patient
  end

    def current_doctor=(doctor)
      @current_doctor = doctor
    end

  def current_patient
    remember_token = Patient.encrypt(cookies[:remember_token])
    @current_patient ||= Patient.find_by(remember_token: remember_token)
  end

  def current_doctor
    remember_token = Patient.encrypt(cookies[:remember_token])
    @current_doctor ||= Doctor.find_by(remember_token: remember_token)
  end

  def patient_signed_in?
    !current_patient.nil?
  end

  def doctor_signed_in?
    !current_doctor.nil?
  end
end
