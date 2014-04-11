class Api::V1::Patients::DoctorsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :verify_api_token

  def department_index
    @departments = Department.in_clinic(@patient)
    @info = 'Departments'
  end

  def index
    #TODO need to find the correct clinic - could be many by the name passed. maybe pass hash with name + id
    @department = Department.in_clinic(@patient).where(name: params[:name]).first
    @doctors = Doctor.in_department(@department)
  end

  def show

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