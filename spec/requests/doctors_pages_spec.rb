require 'spec_helper'

describe "DoctorsPages" do
  subject { page }
  before { switch_to_subdomain('doctors') }

  describe 'Must be signed in to view doctor pages' do
    let(:doctor) { FactoryGirl.create(:doctor) }

    before { visit doctor_path(doctor) }
    it { should have_content 'Sign In' }
    it { should_not have_content "Today's Appointments" }
  end

  describe 'Doctor signin page' do

    before { visit root_path }
    it { should have_title "Sign In"}
    it { should have_content("Sign In") }




    describe 'Doctor signing in' do
      describe 'with invalid information' do
        before { click_button 'Sign in' }
        it { should have_title "Sign In" }
        it { should have_selector 'div.alert.alert-danger',
                                  text: 'Invalid email/password combination' }
      end

      describe 'with valid information' do
        let(:doctor) { FactoryGirl.create(:doctor) }
        let(:department) { FactoryGirl.create(:department) }

        before do
          doctor.save!
          department.save!
          fill_in 'Email', with: 'doctor@example.com'
          fill_in 'Password', with: 'Qwerty1'
          click_button 'Sign in'
        end
        it { should have_title("Today's Appointments") }


        describe 'Visiting signin page when logged in' do
          before { visit root_path }
          it { should have_title "Today's Appointments" }
        end

        describe 'cannot visit another doctors pages' do
          before do
            @doc2 = Doctor.create(email: 'testDoctor@example.com',
                                  first_name: 'ababa',
                                  last_name: 'aavava',
                                  password: 'Foobar1',
                                  password_confirmation: 'Foobar1',
                                  clinic_id: 1)
            visit doctor_path(@doc2)
          end
          it 'should not show other doctors page' do
            #TODO add way to differentiate doctor pages to test difference
          end
        end

        describe 'Profile view page' do
          before { click_link 'My Profile' }
          it { should have_content doctor.first_name }
          it { should have_content doctor.last_name }
          it { should have_content doctor.email }
          it { should have_content doctor.phone_number }
          it { should have_content doctor.degree }
          it { should have_content doctor.alma_mater }
          it { should have_content doctor.description }

          describe 'Edit Profile' do
            before { click_link 'Edit Profile' }
            describe 'with invalid password' do
              before do
                fill_in 'doctor_phone_number', with: '000-000-0000'
                click_button 'Update'
              end
              it { should have_selector 'div.alert.alert-danger', text: 'Invalid password entered.'}
            end

            describe 'with valid password' do
              describe 'with invalid information' do
                before do
                  fill_in 'doctor_first_name', with: ''
                  fill_in 'verify_verify_password', with: 'Qwerty1'
                  click_button 'Update'
                end
                it { should have_selector 'div.alert.alert-danger', text: 'Invalid Parameters Entered' }
              end

              describe 'with valid information' do
                before do
                  fill_in 'doctor_phone_number', with: '000-000-0000'
                  fill_in 'verify_verify_password', with: 'Qwerty1'
                  click_button 'Update'
                end
                it { should have_content '000-000-0000'}
              end
            end
          end
        end
        describe 'signing out' do
          before { click_link 'Sign Out' }
          it { should have_content 'Scheduling Simplified' }
        end
      end
    end

    describe 'Forgot Password Page' do
      let (:doctor) { FactoryGirl.create(:doctor) }
      before do
        doctor.save!
        click_link 'Forgot Password'
      end
      it { should have_content 'Email' }
      it { should have_title 'Forgot Password' }

      describe 'resetting password' do
        before do
          fill_in 'Email', with: doctor.email
          click_button 'Submit'
        end
        it { should have_content 'An email has been sent containing your new password'}
        it 'Email should be sent to user' do
          last_email.to.should include(doctor.email)
        end
      end
    end
  end
end
