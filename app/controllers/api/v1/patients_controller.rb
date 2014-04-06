class Api::V1::PatientsController < ApplicationController
  skip_before_filter :verify_authenticity_token
 # before_filter :verify_api_token

  def index

    @info = 'Logged in'
    @tasks = [{title: 'Profile'},
              {title: 'Appointments'},
              {title:'Browse Doctors'},
              {title: 'Sign Out'}]
  end

  def show
    @info = 'Profile'
    @patient = Patient.first
    #   render status: 200,
    #          json: { success: true,
    #                  info: 'Profile',
    #                  data: {
    #                          patient: @patient.to_json(only: [:first_name,
    #                                                           :last_name,
    #                                                           :email,
    #                                                           :phone_number],
    #                                                    methods: [:avatar_thumb_url])
    #                        }
    #               }
    #
    # else
    #   render status: 401,
    #          json: { success: false,
    #                  info: 'Access Denied - Please log in',
    #                  data: {}}
    # end
  end


  private
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
