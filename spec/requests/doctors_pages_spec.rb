require 'spec_helper'

describe 'DoctorsPages' do
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
    it { should have_title 'Sign In'
    }
    it { should have_content('Sign In') }




    describe 'Doctor signing in' do
      describe 'with invalid information' do
        before { click_button 'Sign in' }
        it { should have_title 'Sign In' }
        it { should have_selector 'div.alert.alert-danger',
                                  text: 'Invalid email/password combination' }
      end

      describe 'with valid information' do
        let(:department) { FactoryGirl.create(:department) }
        let(:doctor) { FactoryGirl.create(:doctor) }
        before do
          department.save!
          doctor.save!
          fill_in 'Email', with: doctor.email
          fill_in 'Password', with: doctor.password
          click_button 'Sign in'
        end
        it { should have_title("My Profile") }


        describe 'Visiting signin page when logged in' do
          before { visit root_path }
          it { should have_title "My Profile" }
        end

        describe 'cannot visit another doctors pages' do
          let(:doctor2) { FactoryGirl.create(:doctor,
                                             email: 'testDoctor@example.com') }
          before do
            doctor2.save
            visit doctor_path(doctor2)
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
              it { should have_selector 'div.alert.alert-danger', text: 'Invalid password entered'}
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

          describe 'Change password page' do
            before { click_link 'Change Password' }
            it { should have_content 'Change Password' }
            it { should have_content 'Old password' }
            it { should have_content 'New password' }
            it { should have_content 'Confirm new password' }
            it { should have_button 'Change' }

            describe 'changing the password' do
              describe 'without adding old password' do
                before do
                  fill_in 'new_password', with: 'Boobado1'
                  fill_in 'new_password_confirm', with: 'Boobado1'
                  click_button 'Change'
                end
                it { should have_content 'Change Password' }
                it { should have_content 'Old password' }
                it { should have_selector 'div.alert.alert-danger', text: 'Old password invalid' }
              end
              describe 'with invalid new password format' do
                before do
                  fill_in 'old_password', with: doctor.password
                  click_button 'Change'
                end
                it { should have_selector 'div.alert.alert-danger',
                            text: 'The form contains 1 error.' }
              end
              describe 'with valid parameters' do
                before do
                  fill_in 'old_password', with: doctor.password
                  fill_in 'new_password', with: 'Boobado1'
                  fill_in 'new_password_confirm', with: 'Boobado1'
                  click_button 'Change'
                end
                it { should have_selector 'div.alert.alert-success', text: 'Password updated' }
              end
            end
          end
        end

        describe 'signing out' do
          before { click_link 'Sign Out' }
          it { should have_content 'Sign in' }
        end
      end
    end

    describe 'Forgot Password Page' do
      let(:doctor) { FactoryGirl.create(:doctor) }
      before do
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
