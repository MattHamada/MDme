# MDme Rails master application
# Author:: Matt Hamada (maito:mattahamada@gmail.com)
# 11/5/14
# Copyright:: Copyright (c) 2014 MDme
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential.

# <tt>Api::V1::Patients::DevicesController</tt> for
# www.mdme.us/api/v1/patients/:patient_id/devices
# All calls need to pass :api_token for validation
# Used for accepting device registration from mobile clients
# Currently only android supported
class Api::V1::Patients::DevicesController < Api::V1::ApplicationController

  skip_before_filter :verify_authenticity_token
  before_filter :verify_api_token

  # POST www.mdme.us/api/v1/patients/:patient_id/devices
  def create
    p = device_params
    @device = Device.new(p)
    if @device.save
      render json: { success: true,
                     info: 'Device saved',
                     data: {}}
    else
      errors = []
      @appointment.errors.full_messages.each { |e| errors << e}
      render json: { success: false,
                     info: "The following #{@device.errors.count} error(s) occured",
                     data: {errors: errors} }
    end
  end

  private
    def device_params
      params.require(:device).permit(:patient_id, :token, :platform)
    end

    def verify_api_token
      @patient ||= Patient.find_by_api_key(my_encrypt(params[:api_token]));
      if @patient.nil?
        render status: 401,
               json: { success: false,
                       info: 'Access Denied - Please log in',
                       data: {}}
      end
    end

end