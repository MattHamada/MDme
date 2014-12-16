require 'spec_helper'

describe Patient do
  let(:clinic) { FactoryGirl.create(:clinic) }
  before { @patient = Patient.new(first_name: "Example",
                                  last_name: 'patient',
                                  email: "user@example.com",
                                  password: 'Qwerty1',
                                  password_confirmation: 'Qwerty1',
                                  clinics: [clinic],
                                  birthday: Date.today - 20.years,
                                  is_male: true,
                                  marital_status: Patient::MaritalStatus::SINGLE,
                                  social_security_number: '123-22-1155',
                                  address1: '123 W first ave',
                                  city: 'Phoenix',
                                  state: 'AZ',
                                  zipcode: '85018')
         }

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
  it { should respond_to(:birthday) }
  it { should respond_to(:name_prefix) }
  it { should respond_to(:name_suffix) }
  it { should respond_to(:middle_initial) }
  it { should respond_to(:is_male) }
  it { should respond_to(:social_security_number) }
  it { should respond_to(:marital_status) }
  it { should respond_to(:address1) }
  it { should respond_to(:address2) }
  it { should respond_to(:city) }
  it { should respond_to(:state) }
  it { should respond_to(:zipcode) }
  it { should respond_to(:home_phone) }
  it { should respond_to(:work_phone) }
  it { should respond_to(:mobile_phone) }
  it { should respond_to(:work_phone_extension) }
  it { should respond_to(:preferred_daytime_phone) }




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

    describe 'A second patient with the same name still has a valid slug' do
      before do
        clinic.save
        @patient2 =  Patient.new(first_name: "Example",
                                 last_name: 'patient',
                                 email: "newEmail@email.com",
                                 password: 'Qwerty1',
                                 password_confirmation: 'Qwerty1',
                                 clinics: [clinic])
        @patient.save
        @patient2.save
      end
      it(@patient)  { should be_valid }
      it(@patient2) { should be_valid }
      its 'slug should have a unique number at the end' do
        @patient.slug.should eq @patient.full_name.parameterize
        @patient2.slug.should eq "#{@patient.slug}-1"
      end
    end
  end

  describe 'with no state' do
    before { @patient.state = nil }
    it { should_not be_valid }
  end
  describe 'State should only accept 2 char abbreviation' do
    before { @patient.state = 'Arizona' }
    it { should_not be_valid }
  end

  describe 'social security number should be less than 12 digits' do
    before { @patient.social_security_number = '1' * 12 }
    it { should_not be_valid }
  end

  describe 'with no sex specified' do
    before { @patient.is_male = nil }
    it { should_not be_valid }
  end

  describe 'with no address1' do
    before { @patient.address1 = nil }
    it {should_not be_valid}
  end

  describe 'with address1 over 100char' do
    before { @patient.address1 = 'a' * 101 }
    it { should_not be_valid }
  end

  describe 'with no city' do
   before { @patient.city = nil }
    it { should_not be_valid }
  end

  describe 'with city name over 50char' do
    before { @patient.city = 'a' * 51 }
    it { should_not be_valid }
  end

  describe 'with no zipcode' do
    before { @patient.zipcode = nil }
    it {should_not be_valid}
  end

  describe 'with address1 over 11char' do
    before { @patient.zipcode = 'a' * 12 }
    it { should_not be_valid }
  end

  describe 'with middle initial over 1char' do
    before { @patient.middle_initial = 'a' * 2 }
    it { should_not be_valid }
  end

  describe 'with no birthday' do
    before { @patient.birthday =nil }
    it { should_not be_valid }
  end

  describe 'with birthday in future' do
    before { @patient.birthday = Date.today + 3.days }
    it { should_not be_valid }
  end
end
