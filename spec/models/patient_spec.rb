require 'spec_helper'

describe Patient do
  before { @patient = Patient.new(name: "Example User", email: "user@example.com", password: 'foobar', password_confirmation: 'foobar') }

  subject { @patient }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }

  it { should be_valid }

  describe 'when name is not present' do
    before { @patient.name = ' ' }
    it { should_not be_valid }
  end

  describe 'when name to long' do
    before { @patient.name = 'a'*51 }
    it { should_not be_valid }
  end

  describe 'when email is not present' do
    before { @patient.email = ' '}
      it { should_not be_valid }
  end

  describe 'with valid email' do
    before { @patient.email = 'test@test.com' }
    specify { expect(@patient).to be_valid }
  end

  describe 'with invalid email ' do
    it 'should be invalid' do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com foo@bar..com]
      addresses.each do |invalid_address|
        @patient.email = invalid_address
        expect(@patient).not_to be_valid
      end
    end
  end

  describe 'when email already taken' do
    before do
      patient_dup = @patient.dup
      patient_dup.email = patient_dup.email.upcase
      patient_dup.save
    end
    it { should_not be_valid }
  end

  describe 'when password not present' do
    before { @patient = Patient.new(name: "Example User", email: "user@example.com", password: '', password_confirmation: '') }
    it { should_not be_valid }
  end

  describe 'when password != password confirmation' do
    before { @patient = Patient.new(name: "Example User", email: "user@example.com", password: 'fizzbuzz', password_confirmation: 'foobar') }
    it { should_not be_valid }
  end

  describe 'when password to short' do
    before { @patient.password = @patient.password_confirmation = 'a'*5 }
    it { should_not be_valid }
  end

  describe 'authentication method' do
    before { @patient.save }
    let(:found_patient) { Patient.find_by(email: @patient.email) }

    describe 'with valid password' do
      it { should eq found_patient.authenticate(@patient.password) }
    end

    describe 'with invalid password' do
      let(:patient_invalid_password) { found_patient.authenticate('invalid') }
      it { should_not eq patient_invalid_password }
      specify { expect(patient_invalid_password).to be_false }
    end
  end




end
