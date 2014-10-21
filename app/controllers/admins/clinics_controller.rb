# MDme Rails master application
# Author:: Matt Hamada (maito:mattahamada@gmail.com)
# 6/7/14
# Copyright:: Copyright (c) 2014 MDme
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential.

# <tt>Admins::ClinicsController</tt> for admin.mdme.us/clinics
class Admins::ClinicsController < ApplicationController

  before_filter :find_admin
  before_filter :find_clinic
  before_filter :require_admin_login
  before_filter :set_active_navbar

  def show
    url = "https://www.mdme.us/clinics/#{@clinic.slug}/checkin"
    @qr = RQRCode::QRCode.new(url, size: 6)
  end

  private
    def find_admin
      @admin ||= Admin.find(params[:admin_id])
    end
    helper_method :find_admin

    def set_active_navbar
      @active = :administration
    end

    def find_clinic
      @clinic = @admin.clinic
    end

end
