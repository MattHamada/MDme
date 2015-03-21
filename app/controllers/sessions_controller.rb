# MDme Rails master application
# Author:: Matt Hamada (maito:mattahamada@gmail.com)
# 10/30/13
# Copyright:: Copyright (c) 2014 MDme
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential.

# +SessionsController+ for sessions and cookies; handles logging in/out
class SessionsController < ApplicationController

  # Signin page for patients on www subdomain
  # GET www.mdme.us/signin
  def new
    @active = :signin
    if patient_signed_in?
      if request.variant.include?(:mobile)
        redirect_to patient_mobile_menu_path(current_patient)
      else
        redirect_to patients_path
      end
    end
  end

  # All web logins go through here regardless of subdomain
  # Stores session info in cookie to keep logged in
  # POST www.mdme.us/sessions
  def create
    if request.subdomain == 'doctors'
      doctor = Doctor.find_by(email: params[:session][:email].downcase)
      if doctor && doctor.authenticate(params[:session][:password])
        sign_in doctor, :doctor
        redirect_to doctor_path(doctor)
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

        if request.variant.include? :mobile
          redirect_to patient_mobile_menu_path(patient)
        else
          redirect_to patient_path(patient)
        end
      else
        flash.now[:danger] = 'Invalid email/password combination'
        render 'new'
      end
    end
  end

  # DELETE www.mdme.us/sessions/:id
  def destroy
    if request.subdomain == 'doctors'
      sign_out :doctor
    elsif request.subdomain =='admin'
      sign_out :admin
    else
      sign_out :patient
    end
    if request.subdomain == 'admin' || request.subdomain == 'doctors'
      redirect_to root_path
    else
      redirect_to '/signin'
    end
  end


end
