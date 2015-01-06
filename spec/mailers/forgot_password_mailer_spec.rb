require 'spec_helper'

describe PasswordResetMailer do
  describe 'reset_email' do
    let(:patient) { FactoryGirl.create(:patient) }
    let(:mail) { PasswordResetMailer.reset_email(patient, 'Qwerty123') }

    it 'renders the headers' do
      expect(mail.subject).to eq('Password Reset')
      expect(mail.to).to eq([patient.email])
      expect(mail.from).to eq(['no-reply@mdme.us'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to have_text('Qwerty123')
    end
  end

end
