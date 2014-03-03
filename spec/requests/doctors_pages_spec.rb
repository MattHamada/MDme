require 'spec_helper'

describe "DoctorsPages" do
  subject { page }
  before { switch_to_subdomain('doctors') }

  describe 'Doctor signin page' do
    before { visit root_path }
    it { should have_title "Sign In"}
    it { should have_content("Sign In") }


    describe 'Doctor signing in' do
      describe 'with invalid information' do
        before { click_button 'Sign in' }
        it { should have_title "Sign In" }
        it { should have_selector 'div.alert.alert-danger', text: 'Invalid email/password combination' }
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
    end
  end
end
