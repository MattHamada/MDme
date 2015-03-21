# MDme Rails master application
# Author:: Matt Hamada (maito:mattahamada@gmail.com)
# 10/28/13
# Copyright:: Copyright (c) 2014 MDme
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential.

# +StaticPagesController+ main pages when not signed in
class StaticPagesController < ApplicationController

  # TODO patients should probably still be able to see home page
  # GET www.mdme.us
  def home
    if patient_signed_in?
      redirect_to patients_path
    end

  end

  # GET www.mdme.us/help
  def help; end

  # GET www.mdme.us/about
  def about
    @active = :about
  end

  # GET www.mdme.us/contact
  def contact
    @active = :contact
  end

  #post www.mdme.us/submit-comment
  def submit_comment
    begin
      name = params[:client][:name]
      email = params[:client][:email]
      phone = params[:client][:phone]
      comment = params[:client][:comment]
      SubmitCommentMailer.send_email(name, email, phone, comment).deliver_later
      render json: {
                 status: true
             }
    rescue => error
      render json: {
               status: false,
               message: $!.message
             }
    end

  end
end


