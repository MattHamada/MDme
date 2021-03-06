# MDme Rails master application
# Author:: Matt Hamada (maito:mattahamada@gmail.com)
# 10/29/13
# Copyright:: Copyright (c) 2014 MDme
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential.

# +PatientsController+ for handling Patient pages on default subdomain (www)
# www.mdme.us/patients
class PatientsController < ApplicationController

  before_filter :require_patient_login
  before_filter :find_patient
  before_filter :get_upcoming_appointment

  # before_action :authenticate_header

  # GET www.mdme.us/patients/:id
  def show
    add_breadcrumb @patient.full_name
    # respond_to do |format|
    #   format.html do |variant|
    #     variant.mobile { render 'patients/mobile/show' }
    #   end
    #   format.json  { render :json => @patient, except: [:created_at,
    #                                                     :updated_at,
    #                                                     :password_digest,
    #                                                     :remember_token] }
    # end
  end

  # GET www.mdme.us/patients/:id/edit
  def edit
    add_breadcrumb 'Home', patients_path
    add_breadcrumb 'My Profile', patient_path(@patient)
    add_breadcrumb 'Edit Profile', edit_patient_path(@patient)
    @active = :profile
    @current_user = @patient
  end

  # POST www.mdme.us/patients/:id
  def update
    if params[:patient].has_key? :password and @patient.authenticate(params[:patient].delete :password)
      @patient.bypass_password_validation = true
      #dont save ss with xxx-xx-#### format
      if params[:patient].has_key? :social_security_number and !valid_ssn_format?(params[:patient][:social_security_number])
       params[:patient].delete :social_security_number
      end
      p = patient_params
      if @patient.update_attributes(p)
        respond_to do |format|
          format.html do
            flash[:success] = 'Account updated'
            redirect_to patient_path(@patient)
          end
          format.json { render json: {status: 'patient updated'} }
        end
      else
        respond_to do |format|
          format.html do
            flash[:error] = ''
            @patient.errors.full_messages.each do |msg|
              flash[:error]  += "#{msg}\n"
            end
            render 'patients/edit'
          end
          format.json { render status: 400, json: { status: 'error', errors: @patient.errors.full_messages } }
        end
      end
    else
      respond_to do |format|
        format.html do
          flash[:error] = 'Invalid password entered'
          render 'patients/edit'
        end
        format.json do
          render status: 401, json: { status: 'error', errors: 'Invalid password entered' }
        end
      end
    end
  end

  # GET www.mdme.us/patients
  def index
    @active = :home
    add_breadcrumb 'Home', patients_path
  end

  # GET www.mdme.us/patients/:id/changepassword
  #DEPRICATED
  def change_password
    @active = :profile
    add_breadcrumb 'Home', patients_path
    add_breadcrumb 'My Profile', patient_path(@patient)
    add_breadcrumb 'Change Password', patient_password_path(@patient)
  end

  # PATCH www.mdme.us/patients/:id/updatepassword
  def update_password
    if @patient.authenticate(params[:oldPassword])
      if @patient.update_attributes(password: params[:newPassword],
                                   password_confirmation: params[:newPasswordConf])
        render status: 201, json: {status: 'Password Changed'}
      else
        render status: 401, json:{status: @patient.errors.full_messages[0]}
      end
    else
      render status: 401, json: {status: 'Old password invalid'}
    end
  end




  #mobile stuff below

  def menu
    render 'patients/mobile/menu'
  end

  private
  def valid_ssn_format?(ssn)
    ssn.match(/[a-zA-Z]/) ? false : true
  end

  def find_patient
    @patient ||= current_patient || Patient.find_by_slug!(params[:id])
  end

    def patient_params
      params.require(:patient).permit(:first_name,
                                      :last_name,
                                      :middle_initial,
                                      :name_prefix,
                                      :name_suffix,
                                      :birthday,
                                      :email,
                                      :password,
                                      :password_confirmation,
                                      :doctor_id,
                                      :home_phone,
                                      :work_phone,
                                      :mobile_phone,
                                      :work_phone_extension,
                                      :sex,
                                      :social_security_number,
                                      :marital_status,
                                      :address1,
                                      :address2,
                                      :city,
                                      :state,
                                      :zipcode,
                                      :avatar)
      end
end
