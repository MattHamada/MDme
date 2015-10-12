# MDme Rails master application
# Author:: Matt Hamada (maito:mattahamada@gmail.com)
# 4/23/14
# Copyright:: Copyright (c) 2014 MDme
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential.

# <tt>Patients::ClinicsController</tt>
# for mdme.us/patients/:patient_id/clinics
class Patients::ClinicsController < ApplicationController

  #TODO remove getdoctors exception
  # before_action :authenticate_header
  before_action :find_patient, :except=>[:open_times, :get_doctors]
  before_action :get_upcoming_appointment, except: [:display, :open_times, :get_doctors]

  def index
    @clinics = @patient.clinics.ordered_name
  end

  def show
    @clinic = Clinic.find(params[:id])
    @doctors = @clinic.doctors
  end

  def open_times
    if params.has_key? :clinic_id and params.has_key? :date and params.has_key? :doctor_id
      @clinic = Clinic.find(params[:clinic_id])
      date = Date.parse(params[:date])
      doctor = Doctor.find(params[:doctor_id])
      @times = @clinic.open_appointment_times(date, doctor)
      if @times.is_a?(Hash)
        render json: {status: 1, error: @times[:error]}
      else
        render json: { status: 0, times: @times }
      end
    else
      render json: {status: 0, times: []}
    end
  end

  # GET mdme.us/patients/:patient_id/clinics/get_doctors
  def get_doctors
    @clinic = Clinic.includes(:doctors).find(params[:clinic_id])
    @doctors = @clinic.doctors
    render :partial=>'patients/clinics/doctors_select', :layout=>false;
  end

  # GET mdme.us/patients/:patient_id/clinics/getdoctors
  #DEPRICATED
  # TODO is this method for api?  Should it return a redirect and json?
  def getdoctors
    #verify user in slug is logged in
    token_passed = params[:token] unless params[:token].nil?
    patient = Patient.find_by_slug!(params[:patient_id])
    if my_encrypt(patient.remember_token) != token_passed
      redirect_to signin_path
    else
      allows_cors
      clinic = Clinic.find_by_name(params[:clinic])
      doctors = Doctor.in_clinic(clinic)
      docnames = []
      doctors.each { |d| docnames << d.full_name }
      render json: {doctors: docnames}
    end
  end

  def display
    @clinic = Clinic.find(params[:id])
    respond_to do |format|
      format.js {}
    end
  end

  private
    def find_patient
      @patient ||= current_patient || Patient.includes(:clinics).find_by_slug!(params[:patient_id]).includes(:clinics)
    end
end
