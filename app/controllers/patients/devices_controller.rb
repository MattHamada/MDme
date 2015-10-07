# MDme Rails master application
# Author:: Matt Hamada (maito:mattahamada@gmail.com)
# 6/26/15
# Copyright:: Copyright (c) 2015 Dynamic Medicine, LLC
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential.

# <tt>Patients::ClinicsController</tt>
# for mdme.us/patients/:patient_id/devices
class Patients::DevicesController < ApplicationController

  before_action :find_patient
  before_action :authenticate_header

  def create
    @device = Device.new(device_params)
    if @device.save
      render json: { success: true,
                     info: 'Device saved',
                     data: {}}
    else
      errors = []
      @device.errors.full_messages.each { |e| errors << e}
      render json: { success: false,
                     info: "The following #{@device.errors.count} error(s) occured",
                     data: {errors: errors} }
    end
  end


  def device_params
    params.require(:device).permit(
                               :patient_id,
                               :platform,
                               :token
    )
  end


  private
    def find_patient
      @patient ||= Patient.find(params[:patient_id])
    end

end
