require 'spec_helper'

describe Appointment do
  before do
    @doctor = Doctor.new(first_name: "Example", last_name: 'Doctor', email: "user@example.com", password: 'foobar', password_confirmation: 'foobar')
    @patient = Patient.new(first_name: "Example", last_name: 'patient', email: "user@example.com", password: 'foobar', password_confirmation: 'foobar')
    @appointment = Appointment.new(doctor_id: @doctor.id, patient_id: @patient.id, appointment_time: "2013-12-20 10:30:00")
  end

  subject { @appointment }
  it { should respond_to(:doctor_id) }
  it { should respond_to(:patient_id) }
  it { should respond_to(:appointment_time) }

  describe 'when doctor_id is missing' do
    before { @appointment.doctor_id = nil }
    it { should_not be_valid }
  end

  describe 'when patient_id is missing' do
    before { @appointment.patient_id = nil }
    it { should_not be_valid }
  end

  describe 'when appointment_time is missing' do
    before { @appointment.appointment_time = nil }
    it { should_not be_valid }
  end

  describe 'doctors should not have more than one appointment at same time' do
    before do
      @appointment2 = @appointment.clone
      @appointment2.save
    end

    it { should_not be_valid }
  end
end

