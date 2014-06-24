class Api::V1::Patients::DoctorsController < ApplicationController
  #TODO probably need to make doctors a subsection of clinics and not patients
  skip_before_filter :verify_authenticity_token
  before_filter :verify_api_token


  #TODO this should be in a clinic browsing api not for patients
  # def department_index
  #   @departments = Department.in_clinic(@patient)
  #   @info = 'Departments'
  # end

  def index
    clinic =  @patient.clinics.where(name: params[:name]).first
    @department = clinic.departments.where(name: params[:name])
    @doctors = Doctor.in_department(@department)
  end

  def show
    @doctor = Doctor.find(params[:id])
    rescue
      render  status: 202,
              json: { success: false,
                      info: 'Doctor not found.',
                      data: {}}
  end

  private
    def verify_api_token
      @patient ||= Patient.find_by_api_key(encrypt(params[:api_token]));
      if @patient.nil?
        render status: 401,
               json: { success: false,
                       info: 'Access Denied - Please log in',
                       data: {}}
      end
    end
end