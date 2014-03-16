require 'spec_helper'

describe Patient do
  before { @patient = Patient.new(first_name: "Example",
                                  last_name: 'patient',
                                  email: "user@example.com",
                                  password: 'Qwerty1',
                                  password_confirmation: 'Qwerty1',
                                  clinic_id: 1) }

  subject { @patient }

  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:slug) }

  it { should be_valid }

  describe 'when first name is not present' do
    before { @patient.first_name = ' ' }
    it { should_not be_valid }
  end

  describe 'when last name not present' do
    before { @patient.last_name = ' '}
    it { should_not be_valid }
  end

  describe 'when first name to long' do
    before { @patient.first_name = 'a'*51 }
    it { should_not be_valid }
  end

  describe 'when last name to long' do
    before { @patient.last_name = 'a'*51 }
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

  describe 'password problems' do
    describe 'when password not present' do
      before {@patient.password = @patient.password_confirmation = ''}
      it { should_not be_valid }
    end

    describe 'when password != password confirmation' do
      before do
        @patient.password = 'Qwerty1'
        @patient.password='YtrewQ1'
      end
      it { should_not be_valid }
    end

    describe 'when password to short' do
      before { @patient.password = @patient.password_confirmation = 'Qwer1' }
      it { should_not be_valid }
    end

    describe 'when password has no capital letters' do
      before { @patient.password = @patient.password_confirmation = 'qwerty1' }
      it { should_not be_valid }
    end

    describe 'when password is all capital' do
      before { @patient.password = @patient.password_confirmation = 'QWERTY1' }
      it { should_not be_valid }
    end

    describe 'when password has no numbers' do
      before { @patient.password = @patient.password_confirmation = 'Qwertyy' }
      it { should_not be_valid }
    end
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

    describe 'remmeber token' do
      before { @patient.save }
      its(:remember_token) { should_not be_blank }
    end
  end

  describe "Slug is set to patients name hyphenated" do
    before { @patient.save }
    its(:slug) { should eq "#{@patient.first_name.downcase}-#{@patient.last_name.downcase}" }

    describe 'A second patient with the same name stil has a valid slug' do
      before do
        @patient2 = @patient.dup
        @patient.save
        @patient2.email = "newEmail@email.com"
        @patient2.save
        puts @patient.slug
        puts @patient2.slug
      end
      it(@patient)  { should be_valid }
      it(@patient2) { should be_valid }
      its 'slug should have a unique number at the end' do
        @patient.slug.should eq @patient.full_name.parameterize
        @patient2.slug.should eq "#{@patient.slug}-1"
      end
    end
  end
end
