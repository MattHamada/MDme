require 'spec_helper'

describe SignupMailer do
  describe 'signup_confirmation' do
    let (:patient) { FactoryGirl.create(:patient) }
    let(:mail) { SignupMailer.signup_confirmation(patient, 'aCAcdaeAD2') }

    it 'renders the headers' do
      expect(mail.subject).to eq('Sign Up Confirmation')
      expect(mail.to).to eq([patient.email])
      expect(mail.from).to eq(['no-reply@mdme.us'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to have_text('aCAcdaeAD2')
    end
  end

end
