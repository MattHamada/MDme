# MDme Rails master application
# Author:: Matt Hamada (maito:mattahamada@gmail.com)
# 3/28/14
# Copyright:: Copyright (c) 2014 MDme
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential.

# <tt>Doctors::PatientsController</tt>
# for doctors.mdme.us/doctors/:doctor_id/patients
class Doctors::PatientsController < ApplicationController

  before_filter :find_doctor
  before_filter :require_doctor_login

  # GET doctors.mdme.us/doctors/:doctor_id/patients
  def index
    @patients = @doctor.patients
  end

  # GET doctors.mdme.us/doctors/:doctor_id/patients/:id
  def show
    @patient = Patient.find_by_slug(params[:id])
    render partial: 'doctors/patients/ajax_show' if request.xhr?
  end

  private

  def find_doctor
    @doctor ||= Doctor.find_by_slug!(params[:doctor_id])
  end

  helper_method :find_doctor
end