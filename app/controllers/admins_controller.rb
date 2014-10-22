# MDme Rails master application
# Author:: Matt Hamada (maito:mattahamada@gmail.com)
# 11/4/13
# Copyright:: Copyright (c) 2014 MDme
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential.

# +AdminsController+ runs on the admins subdomain  admins.mdme.us/admins
class AdminsController < ApplicationController

  before_filter :find_admin, except: [:signin]
  before_filter :require_admin_login, except: :signin

  # Cannot visit signin page when signed in
  # GET admin.mdme.us/admins/signin
  def signin
    if admin_signed_in?
        redirect_to admins_path
    end

  end

  # Shows a list of all confirmed appointments for the current day
  # GET admin.mdme.us/admins
  def index
    @appointments = Appointment.in_clinic(current_admin).
        today.confirmed.order('appointment_time ASC').load.includes([:patient, :doctor])
  end

  # GET admin.mdme.us/admins/:id
  def show
    @active = :administration
  end

  private
    def find_admin
      @admin ||= current_admin
    end
    helper_method :find_admin

end
