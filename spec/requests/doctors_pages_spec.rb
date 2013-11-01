require 'spec_helper'

describe "DoctorsPages" do
  subject { page }

  it 'should test doctors subdomain' do
    switch_to_subdomain('doctors')
    visit root_path
  end


  describe 'signin page' do
    it { should have_title 'Doctor Sign In'}
  end
end
