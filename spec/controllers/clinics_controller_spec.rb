require 'spec_helper'

describe ClinicsController do
  let(:clinic) { FactoryGirl.create(:clinic) }
  let(:doctor) { FactoryGirl.create(:doctor) }
  let(:patient) { FactoryGirl.create(:patient) }
  let(:appointment) { FactoryGirl.create(:appointment_today) }
  before do
    clinic.save!
    doctor.save!
    patient.save!
    appointment.save!
  end
  describe 'checking in' do
    it 'should check in patient' do
      params = {patient_id: patient.id, id: clinic.slug}
      get :checkin, params
      expect(appointment.reload.checked_in).to be_true
    end
  end
end
