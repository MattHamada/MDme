class DoctorsController < ApplicationController
  before_filter :require_admin_login, :only => [:new, :edit, :destroy, :index]


  def home

  end

  def signin

  end

  def index
    @doctors = Doctor.all
  end

  def new
    @doctor = Doctor.new
  end
end
