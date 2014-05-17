# Author: Matt Hamada
# Copyright MDme 2014
#
# Controller main pages when not signed in
#

class StaticPagesController < ApplicationController
  def home
    if patient_signed_in?
      redirect_to patients_path
    end

  end

  def help; end

  def about
    @active = :about
  end

  def contact
    @active = :contact
  end
end


