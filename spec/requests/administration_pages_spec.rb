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
        let (:appointment) { FactoryGirl.create(:appointment) }

        before do
          fill_in 'Email', with: admin.email
          fill_in 'Password', with: admin.password
          click_button 'Sign in'
        end

        it { should have_title 'Admin Panel'}
        it { should_not have_title 'Admin Sign In'}

        describe 'Admin Index Page' do
          it { should have_content 'Browse Appointments'}
          it { should have_content 'Add Appointment'}
          it { should have_content 'Manage Doctors' }
          it { should have_content 'Manage Patients'}
          it { should have_content "Today's Appointments" }




          describe 'Browse appointments' do
            before do
              click_link "Browse Appointments"
              select appointment.appointment_time.year, from: "date[year]"
              select Date::MONTHNAMES[appointment.appointment_time.month], from: "date[month]"
              select appointment.appointment_time.day, from: "date[day]"
              click_button 'Submit'
            end
            it { should have_content "Select Date" }

            it { should have content full_name(Doctor.first) }

          end


        end
      end
    end
  end

end
