class AdminsController < ApplicationController

  before_filter :require_admin_login, :except => :signin


  def signin
    if admin_signed_in?
      redirect_to admins_path
    end

  end



  def index
    @appointments = Appointment.today.order('appointment_time ASC').load
  end

  private
    def require_admin_login
      unless admin_signed_in?
        redirect_to root_path
      end
    end
end
