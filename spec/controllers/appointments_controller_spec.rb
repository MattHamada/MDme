require 'spec_helper'

describe AppointmentsController do
  let(:clinic) { FactoryGirl.create(:clinic) }
  let(:patient) { FactoryGirl.create(:patient, clinics: [clinic]) }
  let(:doctor) { FactoryGirl.create(:doctor) }
  let(:appointment) { FactoryGirl.create(:appointment) }
  before do
    clinic.save
    doctor.save
    patient.save
    appointment.save
  end
  describe 'GET #fill_appointment' do
    it 'should not update the appointment time with an invalid access_key' do
      config = { access_key: 123, id: appointment.id }
      expect do
        get :fill_appointment, config
        appointment.reload
      end.not_to change(appointment, :appointment_time)
    end
    it 'should not change time if user declines offer' do
      config = { access_key: appointment.access_key,
                 id: appointment.id,
                 fill: 'false',
                 new_time: DateTime.now + 3.days }
      expect do
        get :fill_appointment, config
        appointment.reload
      end.not_to change(appointment, :appointment_time)
    end
    it 'should update appointment time with valid access_key' do
      config = { access_key: appointment.access_key,
                 id: appointment.id,
                 fill: 'true',
                 new_time: DateTime.now + 3.days }
      expect do
        get :fill_appointment, config
        appointment.reload
      end.to change(appointment, :appointment_time)
    end
  end
end
