require 'spec_helper'

describe "DoctorsPages" do
  subject { page }
  before { switch_to_subdomain('doctors') }

  describe 'Doctor signin page' do
    before { visit root_path }
    it { should have_title "Doctor's Sign In"}
    it { should have_content("Sign in") }


    describe 'Doctor signing in' do
      describe 'with invalid information' do
        before { click_button 'Sign in' }
        it { should have_title "Doctor's Sign In" }
        it { should have_selector 'div.alert.alert-danger', text: 'Invalid email/password combination' }
      end

      describe 'with valid information' do
        before do
          @doctor = Doctor.create(first_name: 'doc', last_name: 'meds', email: 'doctor@example.com',
                                  password: 'foobar', password_confirmation: 'foobar')
          fill_in 'Email', with: 'doctor@example.com'
          fill_in 'Password', with: 'foobar'
          click_button 'Sign in'
        end
        it { should have_title(full_name(@doctor)) }
      end
    end
  end
end
