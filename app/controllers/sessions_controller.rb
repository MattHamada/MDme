# Author: Matt Hamada
# Copyright MDme 2014
#
# Controller for Sessions; handles logging in/out
#
#


class SessionsController < ApplicationController
  def new

  end

  def create
    if request.subdomain == 'doctors'
      doctor = Doctor.find_by(email: params[:session][:email].downcase)
      if doctor && doctor.authenticate(params[:session][:password])
        sign_in doctor, :doctor
        redirect_to doctors_appointments_path(doctor)
      else
        flash.now[:danger] = 'Invalid email/password combination'
        render 'doctors/signin'
      end
    elsif request.subdomain == 'admin'
      admin = Admin.find_by(email: params[:session][:email].downcase)
      if admin && admin.authenticate(params[:session][:password])
        sign_in admin, :admin
        redirect_to admins_path
      else
        flash[:danger] = 'Access Denied'
        redirect_to root_path
      end
    else
      patient = Patient.find_by(email: params[:session][:email].downcase)
      if patient && patient.authenticate(params[:session][:password])
        sign_in patient, :patient
        redirect_to patient
      else
        flash.now[:danger] = 'Invalid email/password combination'
        render 'new'
      end
    end
  end

  def destroy
    if request.subdomain == 'doctors'
      sign_out :doctor
    elsif request.subdomain =='admin'
      sign_out :admin
    else
      sign_out :patient
    end
    redirect_to root_url
  end

end
