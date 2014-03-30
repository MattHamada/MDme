# Author: Matt Hamada
# Copyright MDme 2014
#
# Controller for admin subdomain
#

class AdminsController < ApplicationController

  before_filter :require_admin_login, :except => :signin

  # cannot visit signin page when signed in
  def signin
    if admin_signed_in?
        redirect_to admins_path
    end

  end

  #TODO remove index, make show admin profile/config the default page, and admin/appointment#index be today's appointments
  # index page shows a list of all confirmed appointments for the current day
  def index
    @admin = admin
    @appointments = Appointment.in_clinic(current_admin).
        today.confirmed.order('appointment_time ASC').load.includes([:patient, :doctor])
  end

  private
    def admin
      @admin ||= current_admin
    end


end
