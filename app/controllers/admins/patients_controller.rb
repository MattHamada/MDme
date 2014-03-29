class Admins::PatientsController < ApplicationController

  def index
    @admin = admin
    @patients = Patient.in_clinic(@admin).ordered_last_name.includes(:doctor)
  end

  def new
    @admin = @current_user = admin
    @patient = Patient.new
  end

  def create
    p = patient_params
    p[:password] = p[:password_confirmation] = generate_random_password
    p[:doctor_id] = params[:doctor][:doctor_id]
    @admin = @current_user = admin
    @patient = Patient.new(p)
    @patient.clinic_id = @admin.clinic_id
    if @patient.save
      flash[:success] = 'Patient Created'
      redirect_to admin_patients_path
    else
      flash.now[:danger] = 'Error Creating Patient'
      render 'new'
    end
  end

  def show
    @admin = admin
    @patient = patient
  end

  def edit
    @admin = @current_user = admin
    @patient = patient
  end

  def update
    @admin = admin
    @patient = patient
    @patient.is_admin_applying_update = true
    @patient.attributes = patient_params
    if patient.save
      flash[:success] = 'Patient Successfully Updated'
      redirect_to admin_patients_path(@admin)
    else
      flash.now[:danger] = 'Invalid Parameters Entered'
      render edit_admin_patient_path(@admin, @patient)
    end
  end

  def destroy
    @admin = admin
    @patient = patient
    id = @patient.id
    if @patient.destroy
      flash[:warning] = 'Patient deleted'
      redirect_to admin_patients_path
    else
      flash.now[:danger] = 'An error has occured'
      render admin_patient_path(@patient)
    end
  end

  def patient_params
    params.require(:patient).permit(:first_name,
                                    :last_name,
                                    :email,
                                    :password,
                                    :password_confirmation,
                                    :doctor_id,
                                    :phone_number,
                                    :avatar)
  end

  private
    def patient
      @patient ||= Patient.find_by_slug!(params[:id])
    end
    helper_method :patient

    def admin
      @admin ||= Admin.find(params[:admin_id])
    end
    helper_method :admin
end