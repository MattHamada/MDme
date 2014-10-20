#MDme Rails master application
# Author:: Matt Hamada (maito:mattahamada@gmail.com)
# Copyright:: Copyright (c) 2014 MDme

# +StaticPagesController+ main pages when not signed in
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


