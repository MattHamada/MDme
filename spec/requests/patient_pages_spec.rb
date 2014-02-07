require 'spec_helper'

describe "Patient Pages" do
  subject { page }
  before { switch_to_subdomain('www') }
  let(:patient) { FactoryGirl.create(:patient) }

  describe 'signing in' do
    before { visit signin_path }
    describe 'with invalid information' do
      before { click_button 'Sign in' }
      it { should have_title 'Sign In' }
      it { should have_selector 'div.alert.alert-danger', text: 'Invalid email/password combination'}
    end

    describe 'with valid information' do
      before do
        fill_in 'Email',    with: patient.email
        fill_in 'Password', with: 'foobar'
        click_button 'Sign in'
      end
      it { should_not have_title 'Sign in' }
    end
  end


  describe 'Profile page' do
    describe 'need to be logged in as patient to view profile' do
      before { visit patient_path(patient) }
      it { should_not have_content patient.email }
    end
  end

  #separated due to swtich to webkit from rack
  describe 'Request an appointment', :js => true do
    let(:appointment) { FactoryGirl.create(:appointment_request) }
    let(:doctor)  { FactoryGirl.create(:doctor) }
    let(:patient) { FactoryGirl.create(:patient) }

    before do
      doctor.save!
      patient.save!
      appointment.save!

      visit root_path
      click_link 'sign in'
      fill_in 'Email', with: patient.email
      fill_in 'Password', with: 'foobar'
      click_button 'Sign in'
      click_link 'Request an Appointment'
    end
    describe 'with invalid (past) date' do
      before do
        fill_in 'appointments_date', with: 3.days.ago.strftime("%F")
        click_button 'Find'
        click_button 'Request'
      end
      it { should have_selector 'div.alert.alert-danger', text: 'Time must be set in the future' }
    end

    describe 'with valid date' do
      before do
        fill_in 'appointments_date', with: 3.days.from_now.strftime("%F")
        click_button 'Find'
        click_button 'Request'
      end
      it { should have_selector 'div.alert.alert-success', text: 'Appointment Requested'}
    end


  end
end


#describe 'Signup page' do
  #  before { visit signup_path }
  #
  #  it { should have_title('Sign up') }
  #  it { should have_content('Sign up') }
  #
  #  describe 'signing up' do
  #    describe 'with invalid info' do
  #      it 'should not create a patient' do
  #        expect { click_button 'Create my account' }.not_to change(Patient, :count)
  #      end
  #    end
  #
  #    describe 'with valid info' do
  #      before do
  #          fill_in 'First name',       with: 'example'
  #          fill_in 'Last name',        with: 'patient'
  #          fill_in 'Email',            with: 'user@example.com'
  #          fill_in 'Password',         with: 'foobar'
  #          fill_in "Confirm Password", with: "foobar"
  #      end
  #      it 'should create a patient' do
  #        expect { click_button 'Create my account' }.to change(Patient, :count).by(1)
  #      end
  #
  #      describe 'after creating the patient' do
  #        before { click_button 'Create my account' }
  #        let(:patient) { Patient.find_by(email: 'user@example.com') }
  #
  #        it { should have_link('Sign out') }
  #        it { should have_title(full_name(patient)) }
  #        it { should have_selector('div.alert.alert-success', text: 'Account Created') }
  #      end
  #    end
  #  end
  #
  #end

