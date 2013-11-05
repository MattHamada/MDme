class AdminsController < ApplicationController

  before_filter :require_admin_login, :except => :signin


  def signin

  end

  def index
  end


  def show
    @appointments = Appointment.today.order('appointment_time ASC').all
  end

  private
    def require_admin_login
      unless admin_signed_in?
        redirect_to root_path
      end
    end
end
