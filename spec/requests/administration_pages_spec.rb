require 'spec_helper'

describe "AdministrationPages" do
  subject { page }
  before { switch_to_subdomain('admin') }

  describe 'root signin page' do
    before { visit root_path }

    it { should have_title('Admin Sign In')}
    it { should have_content('Admin Sign In')}

    describe 'signing in' do
      describe 'wih invalid information' do
        before do
          fill_in 'Email', with: 'wrong@example.com'
          fill_in 'Password', with: 'baddpass'
          click_button 'Sign in'
        end
        it { should have_title('Admin Sign In') }
        it { should have_selector('div.alert.alert-danger', text: 'Access Denied')}
      end

      describe 'with valid information' do
        let(:admin) { FactoryGirl.create(:admin) }
        let(:appointment) { FactoryGirl.create(:appointment) }
        let(:doctor) { FactoryGirl.create(:doctor) }
        let(:patient) { FactoryGirl.create(:patient) }

        before do
          fill_in 'Email', with: admin.email
          fill_in 'Password', with: admin.password
          click_button 'Sign in'
        end

        it { should have_title 'Admin Panel'}
        it { should_not have_title 'Admin Sign In'}

        describe 'Admin Index Page' do
          it { should have_content 'Manage Appointments'}
          it { should have_content 'Manage Doctors' }
          it { should have_content 'Manage Patients'}
          it { should have_content "Today's Appointments" }

          describe 'test' do
            before do
              click_link "Manage Appointments"

            end
            it { should have_selector('#day_appointments') }
            it { should have_content "Select Date" }
          end
        end
      end
    end
  end

  describe 'Browse appointments', :js => true do
    let(:admin) { FactoryGirl.create(:admin) }
    let(:appointment) { FactoryGirl.create(:appointment) }
    let(:doctor) { FactoryGirl.create(:doctor) }
    let(:patient) { FactoryGirl.create(:patient) }
    before do
      doctor.save!
      patient.save!
      appointment.save!
      @admin = Admin.create!(email: 'testAdmin@example.com', password: 'foobar', password_confirmation: 'foobar')

      visit root_path
      fill_in 'Email', with: @admin.email
      fill_in 'Password', with: @admin.password
      click_button 'Sign in'

      click_link "Manage Appointments"
      fill_in 'appointments_date', with: '2013-11-23'
      click_button 'Submit'
      #wait_until { find('#day_appointments') }

    end

    it { should have_selector('#day_appointments') }
    it { should have_content "Select Date" }

    it { should have_content Doctor.first.full_name }

  end
end

