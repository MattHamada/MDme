class PatientsController < ApplicationController
  def new
    @patient = Patient.new
  end

  def create
    @patient = Patient.new(user_params)
    if @patient.save
      sign_in @patient
      flash[:success] = 'Account Created'
      redirect_to @patient
    else
      render 'new'
    end
  end

  def show
    @patient = Patient.find(params[:id])
  end



  def user_params
    params.require(:patient).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end
end
