class Api::V1::PatientsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :verify_api_token

  def index

    @info = 'Logged in'
    @tasks = [{title: 'Profile'},
              {title: 'Appointments'},
              {title:'Browse Doctors'},
              {title: 'Sign Out'}]
  end

  def show
    #TODO update to give 300x300 image, not thumb
    @info = 'Profile'
  end

  def update
    @patient.is_admin_applying_update = true
    if params[:patient].has_key?(:avatar)
      @patient.avatar = params[:patient][:avatar]
      @patient.save
    end
    if @patient.update_attributes(patient_params)
      render status: 200,
             json: { success: true,
                     info: 'Profile Updated',
                     data: {}}
    else
      render status: 202,
             json: { success: false,
                     info: 'Invalid Parameters',
                     data: @patient.errors.messages}
    end
  end


  private

  def patient_params
    params.require(:patient).permit(:first_name,
                                    :last_name,
                                    :email,
                                    :phone_number,
                                    :avatar)
  end
  def verify_api_token
    @patient ||= Patient.find_by_remember_token(encrypt(params[:api_token]));
    if @patient.nil?
      render status: 401,
             json: { success: false,
                     info: 'Access Denied - Please log in',
                     data: {}}
    end
  end
end
