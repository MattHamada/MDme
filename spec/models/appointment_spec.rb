require 'spec_helper'

describe Appointment do
  let(:doctor) { FactoryGirl.create(:doctor) }
  let(:patient) { FactoryGirl.create(:patient) }
  before do
    doctor.save
    patient.save
    @appointment = Appointment.new(doctor_id: doctor.id,
                                   patient_id: patient.id,
                                   appointment_time: DateTime.now + 30.minutes,
                                   clinic_id: 1)
  end

  subject { @appointment }
  it { should respond_to(:doctor_id) }
  it { should respond_to(:patient_id) }
  it { should respond_to(:appointment_time) }
  it { should respond_to(:clinic_id) }
  it { should be_valid }

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

  it 'should show up in given date of today' do
    Appointment.given_date(DateTime.now + 30.minutes).should
                                     match_array([@appointment])
  end

  it 'should show up in appointments with same doctor' do
    Appointment.with_doctor(@appointment.doctor_id).should
                                    match_array([@appointment])
  end
end

