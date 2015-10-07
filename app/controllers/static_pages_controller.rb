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
      redirect_to patient_path(current_patient)
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
      @message = 'Message submitted'
      respond_to do |format|
        format.json do
          render json: {
                     status: true
                 }
        end
        format.js do
          @status = :success;
        end
        format.html do
          flash[:success] = @message
          redirect_to contact_path
        end
      end

    rescue => error
      @message = 'An error occurred.  Please try again later'
      respond_to do |format|
        format.json do
          render json: {
                     status: false,
                     message: $!.message
                 }
        end
        format.js do
          @status = :danger
        end
        format.html do
          flash[:danger] = message
          redirect_to contact_path
        end
      end
    end
  end
end


