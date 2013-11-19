require 'spec_helper'

describe Doctor do
  before { @doctor = Doctor.new(first_name: "Example", last_name: 'Doctor', email: "user@example.com", password: 'foobar', password_confirmation: 'foobar') }

  subject { @doctor }

  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:department)}
  it { should respond_to(:patients)}
  it { should respond_to(:appointments)}



  describe 'creating a doctor' do
    describe 'invalid with missing first name' do
      before { @doctor.first_name = ' ' }
      it { should_not be_valid }
    end

    describe 'invalid with missing last name' do
      before { @doctor.last_name = ' ' }
      it { should_not be_valid }
    end

    describe 'invalid with missing email' do
      before { @doctor.email = ' ' }
      it { should_not be_valid }
    end

    describe 'invalid with improper email format' do
      before { @doctor.email = '3/2x@xda.xac.p' }
      it { should_not be_valid }
    end

    describe 'invalid with missing password' do
      before { @doctor = Doctor.new(first_name: 'boo', last_name: 'radley', email: 'boo@radley.com',
                                password: ' ', password_confirmation: ' ') }
      it { should_not be_valid }
    end

    describe 'invalid with short password' do
      before { @doctor.password = '1234' }
      it { should_not be_valid }
    end
  end

  describe 'full_name method returns first and last name' do
    before { @doctor.save }
    its(:full_name) { should eq "#{@doctor.first_name} #{@doctor.last_name}" }
  end

  describe 'updating doctor as admin bypasses password validation' do
    describe 'without admin set' do
      before do
        @doctor.password = ''
        @doctor.password_confirmation = ''
      end
      it { should_not be_valid }
    end

    describe 'with admin set' do
      before do
        @doctor = Doctor.new(first_name: "Example", last_name: 'Doctor', email: "user@example.com", password: '1', password_confirmation: '1')
        @doctor.is_admin_applying_update = true
      end
      it { should be_valid }
    end

  end



end
