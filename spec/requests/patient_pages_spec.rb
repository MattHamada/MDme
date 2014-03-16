require 'spec_helper'

describe "Patient Pages" do
  subject { page }
  before { switch_to_subdomain('www') }
  let(:patient) { FactoryGirl.create(:patient) }

  describe 'need to be logged in to access patient pages' do
    before { visit patient_path(patient) }
    it { should have_content 'Scheduling Simplified' }
  end

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
        fill_in 'Password', with: 'Qwerty1'
        click_button 'Sign in'
      end
      it { should_not have_title 'Sign in' }
      it { should have_content 'Sign Out' }

      describe 'cannot view pages of another patient' do
      before do
        @patient2 = Patient.create!(first_name: 'bbbdb',
                                    last_name: 'baaba',
                                    email: 'test2@test.com',
                                    password: 'Foobar1',
                                    password_confirmation: 'Foobar1',
                                    clinic_id: 1)
        visit patient_path(@patient2)
      end
      it { should have_content 'Scheduling Simplified' }
      end

    end


    describe 'Forgot Password Page' do
      before do
        click_link 'Forgot Password'
      end
      it { should have_content 'Email' }
      it { should have_title 'Forgot Password' }

      describe 'resetting password' do
        before do
          fill_in 'Email', with: patient.email
          click_button 'Submit'
        end
        it { should have_content 'An email has been sent containing your new password'}
        it 'Email should be sent to user' do
          last_email.to.should include(patient.email)
        end
      end
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
      fill_in 'Password', with: 'Qwerty1'
      click_button 'Sign in'
      click_link 'Request an Appointment'
    end
    describe 'with invalid (past) date' do
      before do
        fill_in 'appointments_date', with: 3.days.ago.strftime("%F")
        click_button 'Find open times'
        click_button 'Request'
      end
      it { should have_selector 'div.alert.alert-danger', text: 'Time must be set in the future' }
    end

    describe 'with valid date' do
      before do
        fill_in 'appointments_date', with: 3.days.from_now.strftime("%F")
        click_button 'Find open times'
        click_button 'Request'
      end
      it { should have_selector 'div.alert.alert-success', text: 'Appointment Requested'}
    end

    describe 'Can only choose doctors in same clinic' do
      let(:doctor2) { FactoryGirl.create(:doctor,
                                         email: 'newDoc@doc.com',
                                         clinic_id: 2) }
      before do
        doctor2.save
        click_link 'Request an Appointment'
        puts find(:css, 'select#doctor_doctor_id').value
      end
      it 'should not list doctor2 in available doctors' do
        find(:css, 'select#doctor_doctor_id').value.should_not eq 2
      end
    end

    #describe 'cannot make appointments on taken times' do
    #  before do
    #    fill_in 'appointments_date', with: 3.days.from_now.strftime("%F")
    #    click_button 'Find open times'
    #    click_button 'Request'
    #    click_link 'Request an Appointment'
    #    fill_in 'appointments_date', with: 3.days.from_now.strftime("%F")
    #    click_button 'Find open times'
    #  end
    #  it 'should not create an appointment' do
    #    expect{click_button 'Request'}.not_to change(Appointment, :count).by(1)
    #  end
    #end



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

