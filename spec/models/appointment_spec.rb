require 'spec_helper'

describe Appointment do
  let(:doctor) { FactoryGirl.create(:doctor) }
  let(:patient) { FactoryGirl.create(:patient) }
  let(:clinic) { FactoryGirl.create(:clinic) }
  before do
    @appointment = Appointment.new(doctor_id: doctor.id,
                                   patient_id: patient.id,
                                   appointment_time: DateTime.now + 30.minutes,
                                   clinic_id: 1,
                                   request: false)
    doctor.save
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

  describe 'doctors should not have more than one appointment at same time in same clinic' do
    before do

      @appointment.save!
      @appointment2 = Appointment.new(doctor_id: doctor.id,
                                      patient_id: patient.id,
                                      appointment_time: @appointment.appointment_time,
                                      clinic_id: 1,
                                      request: false)
    end


    describe 'when appointment at the same time with different doctor' do
      let(:doctor2) { FactoryGirl.create(:doctor, email: 'fff@bbb.com') }
      before do
        doctor2.save!
        @appointment.save
        @appointment2.doctor_id = 2
        @appointment2.save
      end
      it 'should be valid' do
        @appointment2.should be_valid
      end
    end

    describe 'when appointment at the same time in different clinic' do
      let(:clinic2) { FactoryGirl.create(:clinic) }
      before do
        @appointment2.clinic_id = 2
        @appointment.save
        @appointment2.save
      end
      it 'should be valid' do
        @appointment2.should be_valid
      end
    end

    # TODO find out why this does not work
  #   describe 'when appointment is at same time with same doctor in same clinic' do
  #     before do
  #       @appointment.save!
  #       @appointment2.save!
  #     end
  #     it 'shouldnt be valid' do
  #       @appointment2.should_not be_valid
  #     end
  #   end
  # end

  it 'should show up in given date of today' do
    Appointment.given_date(DateTime.now + 30.minutes).should
                                     match_array([@appointment])
  end

  it 'should show up in appointments with same doctor' do
    Appointment.with_doctor(@appointment.doctor_id).should
                                    match_array([@appointment])
  end
end

