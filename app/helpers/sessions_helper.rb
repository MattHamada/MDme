module SessionsHelper

  def require_admin_login
    unless admin_signed_in?
      redirect_to root_path
    end
  end

  def require_patient_login
    if patient_signed_in?
      unless current_patient == Patient.find(params[:id])
        redirect_to root_path
      end
    else
      redirect_to root_path
    end
  end

  def require_admin_or_patient_login
    if admin_signed_in? or patient_signed_in?
      if patient_signed_in?
        require_patient_login
      end
    else
      redirect_to root_path
    end
  end

  def require_doctor_login
    if doctor_signed_in?
      unless current_doctor == Doctor.find(params[:id])
        redirect_to root_path
      end
    else
      redirect_to root_path
    end
  end

  def require_admin_or_doctor_login
    if admin_signed_in? or doctor_signed_in?
      if doctor_signed_in?
        require_doctor_login
      end
    else
      redirect_to root_path
    end
  end


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

    elsif type == :admin
      remember_token = Patient.new_remember_token
      cookies.permanent[:remember_token] = remember_token
      user.update_attribute(:remember_token, Patient.encrypt(remember_token))
      self.current_admin = user
    end

  end

  def sign_out(type)
    cookies.delete(:remember_token)
    if type == :patient
      self.current_patient = nil
    elsif type == :doctor
      self.current_doctor = nil
    elsif type == :admin
      self.current_admin = nil
    end
  end

  def current_patient=(patient)
    @current_patient = patient
  end

  def current_doctor=(doctor)
    @current_doctor = doctor
  end

  def current_admin=(admin)
    @current_admin = admin
  end

  def current_patient
    remember_token = Patient.encrypt(cookies[:remember_token])
    @current_patient ||= Patient.find_by(remember_token: remember_token)
  end

  def current_doctor
    remember_token = Patient.encrypt(cookies[:remember_token])
    @current_doctor ||= Doctor.find_by(remember_token: remember_token)
  end

  def current_admin
    remember_token = Patient.encrypt(cookies[:remember_token])
    @current_admin ||= Admin.find_by(remember_token: remember_token)
  end

  def patient_signed_in?
    !current_patient.nil?
  end

  def doctor_signed_in?
    !current_doctor.nil?
  end

  def admin_signed_in?
    !current_admin.nil?
  end
end
