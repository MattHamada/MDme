require 'spec_helper'

describe "DoctorsPages" do
  subject { page }
  before { switch_to_subdomain('doctors') }

  describe 'signin page' do
    before { visit root_path }
    it { should have_title 'Doctor Sign In'}
    it { should have_content('doctors login') }
  end

  describe 'signing in' do
    describe 'with invalid information' do
      before { click_button 'Sign in' }
      it { should have_title 'Doctor Sign In' }
      it { should have_selector 'div.alert.alert-danger', text: 'invalid login' }
    end

    describe 'with valid information' do
      before do
        @doctor = Doctor.create(fname: 'doc', lname: 'meds', email: 'doctor@example.com',
                                password: 'foobar', password_confirmation: 'foobar')
        fill_in 'Email', 'doctor@example.com'
        fill_in 'Password', 'foobar'
        click_button 'Log in'
      end
      it { should have_title(full_name(@doctor)) }
end
  end
end
