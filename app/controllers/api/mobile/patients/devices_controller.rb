# MDme Rails master application
# Author:: Matt Hamada (maito:mattahamada@gmail.com)
# 7/27/15
# Copyright:: Copyright (c) 2015 Dynamic Medicine, LLC
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential.

# <tt>Api::Mobile::Patients::DevicesController</tt>
# for mdme.us/api/mobile/patients/:patient_id/devices
class Api::Mobile::Patients::DevicesController < Api::Mobile::MobileApplicationController

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
end