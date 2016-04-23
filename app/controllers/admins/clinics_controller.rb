# MDme Rails master application
# Author:: Matt Hamada (maito:mattahamada@gmail.com)
# 6/7/14
# Copyright:: Copyright (c) 2014 MDme
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential.

# <tt>Admins::ClinicsController</tt> for admin.mdme.us/admins/:admin_id/clinics
class Admins::ClinicsController < Admins::ApplicationController

  before_filter :find_admin
  before_filter :find_clinic
  before_filter :require_admin_login
  before_filter :set_active_navbar

  # Generates a QR code used for checking in from mobile
  # GET admin.mdme.us/admins/:admin_id/clinics/:id
  def show
    url = "https://www.mdme.us/clinics/#{@clinic.slug}/checkin"
    @qr = RQRCode::QRCode.new(url, size: 6)
  end

  def open_times
    if params[:date].present? and
        params[:appointment][:doctor_id].present? and
        params[:time_of_day].present?

      @clinic = Clinic.find(params[:appointment][:clinic_id])
      doctor = Doctor.find(params[:appointment][:doctor_id])
      date = Date.strptime(params[:date], '%m/%d/%Y')
      # @times = @clinic.open_appointment_times(date, doctor)

      #todo respond with appointments table
      @days_times = @clinic.open_appointment_times_day_range(
          (date - 1.day), (date + 1.day), doctor, params[:time_of_day]
      )
      # @dates_times = []
      # start_day = @Date.parse(Time.at(params[:day_start].to_i).to_s)
      # @dates << start_day
      # @dates << start_day + 1.day
      # @dates << start_day + 2.days
      # @dates << @Date.parse(Time.at(params[:day_start].to_i).to_s)
      # @times = []
      # @dates.each do |date|
      #   newTimes = []
      #   newTimes << @clinic.open_appointment_times(date, doctor)
      #   @times << newTimes
      # end
      respond_to do |format|
        format.js do
        end
        format.json do
          if @times.is_a?(Hash)
            render json: {status: 1, error: @times[:error]}
          else
            render json: { status: 0, times: @times }
          end
        end
      end
    else
      respond_to do |format|
        format.json do
          render json: {status: 0, times: []}
        end
        format.js do
          render :nothing=>true
        end
      end
    end
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
