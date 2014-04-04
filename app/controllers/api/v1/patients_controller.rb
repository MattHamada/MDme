class Api::V1::PatientsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :verify_api_token

 def index
   if @patient
     render status: 200,
            json: { success: true,
                    info: 'Logged in',
                    data: {
                        tasks:[
                                {title:'Profile'},
                                {title:'Appointments'},
                                {title:'Browse Doctors'},
                                {title:'Sign Out'}
                              ]
                          }
                  }
   else
     render status: 401,
            json: { success: false,
                    info: 'Access Denied - Please log in',
                    data: {}}

   end
 end


  private
  def verify_api_token
    @patient ||= Patient.find_by_remember_token(encrypt(params[:api_token]));
  end
end
