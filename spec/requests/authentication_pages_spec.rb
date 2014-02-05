require 'spec_helper'

describe "AuthenticationPages" do
  subject { page }
  before { switch_to_subdomain('www') }

  describe 'signin page' do
    before { visit signin_path }

    it { should have_content('Sign in') }
    it { should have_title('Sign in') }

    describe 'with invalid information' do
      before { click_button 'Sign in' }

      it { should have_title('Sign in') }
      it { should have_selector('div.alert.alert-danger', text: 'Invalid') }
    end

    describe 'with valid information' do
      let(:patient) { FactoryGirl.create(:patient) }

      before do
        fill_in 'Email',    with: patient.email.downcase
        fill_in 'Password', with: patient.password
        click_button 'Sign in'
      end

      it { should have_title(full_name(patient)) }
      #it { should have_link('My Account', href: patient_path(patient)) }
      it { should have_link('sign out', href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }

      describe 'signing out' do
        before { click_link 'sign out' }
        it { should have_link('sign in') }
      end
    end
  end
end
