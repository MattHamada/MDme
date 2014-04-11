class Api::V1::Patients::AppointmentsController < ApplicationController

  skip_before_filter :verify_authenticity_token
  before_filter :verify_api_token

  def tasks
    @tasks = [{title: 'Confirmed Appointments'},
              {title: 'New Request'},
              {title:'Open Requests'}]
  end

  private
    def verify_api_token
      @patient ||= Patient.find_by_api_key(encrypt(params[:api_token]));
      if @patient.nil?
        render status: 401,
               json: { success: false,
                       info: 'Access Denied - Please log in',
                       data: {}}
      end
    end
end

