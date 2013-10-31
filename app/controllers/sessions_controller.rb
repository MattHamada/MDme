class SessionsController < ApplicationController
  def new

  end

  def create
    patient = Patient.find_by(email: params[:session][:email].downcase)
    if patient && patient.authenticate(params[:session][:password])
      sign_in patient
      redirect_to patient
    else
      #use flash.now since rendering not redirecting
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end
end
