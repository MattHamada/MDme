# MDme Rails master application
# Author:: Matt Hamada (maito:mattahamada@gmail.com)
# 10/30/13
# Copyright:: Copyright (c) 2014 MDme
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential.

# +SessionsController+ for sessions and cookies; handles logging in/out
class SessionsController < ApplicationController
  include AuthToken

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
        sign_in doctor, :doctors
        # token = AuthToken.issue_token({user_id: doctor.id})
        redirect_to doctor_path(doctor)
      else
        flash.now[:danger] = 'Invalid email/password combination'
        render 'doctors/signin'
      end
    elsif request.subdomain == 'admin'
      admin = Admin.find_by(email: params[:email].downcase)
      if admin && admin.authenticate(params[:password])
        # sign_in admin, :admin
        # redirect_to admins_path
        token = AuthToken.issue_token({admin_id: admin.id})
        render json: {
                   admin_id: admin.id,
                   clinic_id: admin.clinic.id,
                   api_token: {
                       token: token
                   }
               }
      else
        render json: { error: 'Invalid email/password combination' }, status: :unauthorized
      end
    else
      patient = Patient.find_by(email: params[:email].downcase)
      respond_to do |format|
        if patient && patient.authenticate(params[:password])
          format.html do
            sign_in patient, :patient
            redirect_to patient
          end
          format.json do
            token = AuthToken.issue_token({user_id: patient.id})
            render json: {
                       user_id: patient.id,
                       api_token: {
                           token: token
                       }
                   }
          end
        else
          format.html do
            flash.now[:danger] = 'Invalid email/password combination'
            render request.path
          end
          format.json do
            render json: { error: 'Invalid email/password combination' }, status: :unauthorized
          end
        end
      end
    end
  end

  # DELETE www.mdme.us/sessions/:id
  def destroy
    if request.subdomain == 'doctors'
      sign_out :doctors
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
