require 'spec_helper'

describe Appointment do
  let(:doctors) { FactoryGirl.create(:doctors) }
  let(:patient) { FactoryGirl.create(:patient) }
  let(:clinic) { FactoryGirl.create(:clinic) }
  before do
    clinic.save
    patient.save
    @appointment = Appointment.new(doctor_id: doctor.id,
                                   patient_id: patient.id,
                                   appointment_time: DateTime.now + 30.minutes,
                                   clinic_id: 1,
                                   status: 'confirmed')
    doctor.save
  end

  subject { @appointment }
  it { is_expected.to respond_to(:doctor_id) }
  it { is_expected.to respond_to(:patient_id) }
  it { is_expected.to respond_to(:appointment_time) }
  it { is_expected.to respond_to(:clinic_id) }
  it { is_expected.to be_valid }

  describe 'when doctor_id is missing' do
    before { @appointment.doctor_id = nil }
    it { is_expected.not_to be_valid }
  end

  describe 'when patient_id is missing' do
    before { @appointment.patient_id = nil }
    it { is_expected.not_to be_valid }
  end

  describe 'when appointment_time is missing' do
    before { @appointment.appointment_time = nil }
    it { is_expected.not_to be_valid }
  end

  describe 'doctors should not have more than one appointment at same time in same clinic' do
    before do

      @appointment.save!
      @appointment2 = Appointment.new(doctor_id: doctor.id,
                                      patient_id: patient.id,
                                      appointment_time: @appointment.appointment_time,
                                      clinic_id: 1,
                                      status: 'confirmed')
    end


    describe 'when appointment at the same time with different doctor' do
      let(:doctor2) { FactoryGirl.create(:doctors, email: 'fff@bbb.com') }
      before do
        doctor2.save!
        @appointment.save
        @appointment2.doctor_id = 2
        @appointment2.save
      end
      it 'should be valid' do
        expect(@appointment2).to be_valid
      end
    end

    describe 'when appointment at the same time in different clinic' do
      let(:clinic2) { FactoryGirl.create(:clinic) }
      before do
        clinic2.save
        @appointment2.clinic_id = 2
        @appointment.save
        @appointment2.save
      end
      it 'should be valid' do
        expect(@appointment2).to be_valid
      end
    end

    describe 'should be able to search by date and by doctor id' do
      before { @appointment.save }
      it 'should show up in appointments with given day' do
        expect(Appointment.given_date(DateTime.now + 30.minutes)).to match_array([@appointment])
      end

      it 'should show up in appointments with same doctor' do
        expect(Appointment.with_doctor(@appointment.doctor_id)).to match_array([@appointment])
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
  end
end

