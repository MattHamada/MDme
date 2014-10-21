# MDme Rails master application
# Author:: Matt Hamada (maito:mattahamada@gmail.com)
# 10/28/13
# Copyright:: Copyright (c) 2014 MDme
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential.

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


