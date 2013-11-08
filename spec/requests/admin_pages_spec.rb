require 'spec_helper'

describe "AdminPages" do
  subject { page }
  before { switch_to_subdomain('admin') }

  describe 'Signin page' do
    before { visit root_path }
    it { should have_title 'Admin Sign In' }
    it { should have_content 'Admin Sign In' }

    describe 'signing in' do
      describe 'with invalid information' do
        before { click_button 'Sign in' }
        it { should have_title 'Admin Sign In' }
        it { should have_selector 'div.alert.alert-danger', text: 'Invalid email/password combination' }
      end

      describe 'with valid information' do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          admin.save
          fill_in 'Email',    with: admin.email
          fill_in 'Password', with: 'foobar'
          click_button 'Sign in'
        end
        it { should have_content("Today's Appointments")}

        describe 'creating appointments page' do
          before { click_link 'Manage Appointments' }

        end
      end
    end



  end


end
