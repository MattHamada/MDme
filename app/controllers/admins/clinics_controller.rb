class Admins::ClinicsController < ApplicationController

  before_filter :find_admin
  before_filter :find_clinic
  before_filter :require_admin_login
  before_filter :set_active_navbar

  def show
    #will need to add patients pid as get param to request from mobile
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
