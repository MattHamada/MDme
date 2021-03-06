require 'spec_helper'

describe PatientMailer do
  describe 'appointment_delayed_email' do
    let(:patient) { FactoryGirl.create(:patient) }
    let(:doctors) { FactoryGirl.create(:doctors) }
    let(:appointment) { FactoryGirl.create(:appointment) }
    let(:clinic) { FactoryGirl.create(:clinic) }
    let(:mail) { PatientMailer.appointment_delayed_email(patient,
                                     appointment.appointment_delayed_time) }
    before do
      clinic.save
      doctor.save
    end

    it 'renders the headers' do
      expect(mail.subject).to eq('Appointment time changed')
      expect(mail.to).to eq([patient.email])
      expect(mail.from).to eq(['no-reply@mdme.us'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to have_text(appointment.appointment_delayed_time.
                                         strftime('%m-%e-%y %I:%M%p'))
    end
  end

end
