require 'spec_helper'

describe "Patient Pages" do
  subject { page }

  describe 'Signup page' do
    before { visit signup_path }

    it { should have_title('Sign up') }
    it { should have_content('Sign up') }

    describe 'signing up' do
      describe 'with invalid info' do
        it 'should not create a patient' do
          expect { click_button 'Create my account' }.not_to change(Patient, :count)
        end
      end

      describe 'with valid info' do
        before do
            fill_in 'First name',       with: 'example'
            fill_in 'Last name',        with: 'patient'
            fill_in 'Email',            with: 'user@example.com'
            fill_in 'Password',         with: 'foobar'
            fill_in "Confirm Password", with: "foobar"
        end
        it 'should create a patient' do
          expect { click_button 'Create my account' }.to change(Patient, :count).by(1)
        end
      end
    end

  end

  describe 'Profile page' do
    let(:patient) { FactoryGirl.create(:patient) }

    before { visit patient_path(patient) }

    it { should have_content full_name(patient) }
    it { should have_content patient.email }
  end
end
