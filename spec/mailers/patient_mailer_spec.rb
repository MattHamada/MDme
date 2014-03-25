require 'spec_helper'

describe PatientMailer do
  describe 'appointment_delayed_email' do
    let(:patient) { FactoryGirl.create(:patient) }
    let(:doctor) { FactoryGirl.create(:doctor) }
    let(:appointment) { FactoryGirl.create(:appointment) }
    let(:mail) { PatientMailer.appointment_delayed_email(patient,
                                     appointment.appointment_delayed_time) }
    before { doctor.save }

    it 'renders the headers' do
      mail.subject.should eq('Appointment time changed')
      mail.to.should eq([patient.email])
      mail.from.should eq(['no-reply@mdme.us'])
    end

    it 'renders the body' do
      mail.body.encoded.should have_text(appointment.appointment_delayed_time.
                                         strftime('%m-%e-%y %I:%M%p'))
    end
  end

end
