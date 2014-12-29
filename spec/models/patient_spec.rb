require 'spec_helper'

describe Patient do
  let(:clinic) { FactoryGirl.build(:clinic) }
  before do
    #comment out stub to call real api
    allow(clinic).to receive(:call_google_api_for_location).and_return(
        {
            "results" => [
                {
                    "address_components" => [
                        {
                            "long_name" => "55",
                            "short_name" => "55",
                            "types" => [ "street_number" ]
                        },
                        {
                            "long_name" => "Fruit Street",
                            "short_name" => "Fruit St",
                            "types" => [ "route" ]
                        },
                        {
                            "long_name" => "West End",
                            "short_name" => "West End",
                            "types" => [ "neighborhood", "political" ]
                        },
                        {
                            "long_name" => "Boston",
                            "short_name" => "Boston",
                            "types" => [ "locality", "political" ]
                        },
                        {
                            "long_name" => "Suffolk County",
                            "short_name" => "Suffolk County",
                            "types" => [ "administrative_area_level_2", "political" ]
                        },
                        {
                            "long_name" => "Massachusetts",
                            "short_name" => "MA",
                            "types" => [ "administrative_area_level_1", "political" ]
                        },
                        {
                            "long_name" => "United States",
                            "short_name" => "US",
                            "types" => [ "country", "political" ]
                        },
                        {
                            "long_name" => "02114",
                            "short_name" => "02114",
                            "types" => [ "postal_code" ]
                        }
                    ],
                    "formatted_address" => "55 Fruit Street, Boston, MA 02114, USA",
                    "geometry" => {
                        "location" => {
                            "lat" => 42.3632091,
                            "lng" => -71.0686487
                        },
                        "location_type" => "ROOFTOP",
                        "viewport" => {
                            "northeast" => {
                                "lat" => 42.3645580802915,
                                "lng" => -71.0672997197085
                            },
                            "southwest" => {
                                "lat" => 42.3618601197085,
                                "lng" => -71.06999768029151
                            }
                        }
                    },
                    "types" => [ "street_address" ]
                }
            ],
            "status" => "OK"
        }.to_json
    )
    clinic.save!
    @patient = Patient.new(first_name: "Example",
                           last_name: 'patient',
                           email: "user@example.com",
                           password: 'Qwerty1',
                           password_confirmation: 'Qwerty1',
                           clinics: [clinic],
                           birthday: Date.today - 20.years,
                           sex: Patient::Sex::MALE,
                           marital_status: Patient::MaritalStatus::SINGLE,
                           social_security_number: '123-22-1155',
                           address1: '123 W first ave',
                           city: 'Phoenix',
                           state: 'AZ',
                           zipcode: '85018')
  end

  subject { @patient }

  it { is_expected.to respond_to(:first_name) }
  it { is_expected.to respond_to(:last_name) }
  it { is_expected.to respond_to(:email) }
  it { is_expected.to respond_to(:password_digest) }
  it { is_expected.to respond_to(:password) }
  it { is_expected.to respond_to(:password_confirmation) }
  it { is_expected.to respond_to(:remember_token) }
  it { is_expected.to respond_to(:authenticate) }
  it { is_expected.to respond_to(:slug) }
  it { is_expected.to respond_to(:birthday) }
  it { is_expected.to respond_to(:name_prefix) }
  it { is_expected.to respond_to(:name_suffix) }
  it { is_expected.to respond_to(:middle_initial) }
  it { is_expected.to respond_to(:sex) }
  it { is_expected.to respond_to(:social_security_number) }
  it { is_expected.to respond_to(:marital_status) }
  it { is_expected.to respond_to(:address1) }
  it { is_expected.to respond_to(:address2) }
  it { is_expected.to respond_to(:city) }
  it { is_expected.to respond_to(:state) }
  it { is_expected.to respond_to(:zipcode) }
  it { is_expected.to respond_to(:home_phone) }
  it { is_expected.to respond_to(:work_phone) }
  it { is_expected.to respond_to(:mobile_phone) }
  it { is_expected.to respond_to(:work_phone_extension) }
  it { is_expected.to respond_to(:preferred_daytime_phone) }




  it { is_expected.to be_valid }

  describe 'when first name is not present' do
    before { @patient.first_name = ' ' }
    it { is_expected.not_to be_valid }
  end

  describe 'when last name not present' do
    before { @patient.last_name = ' '}
    it { is_expected.not_to be_valid }
  end

  describe 'when first name to long' do
    before { @patient.first_name = 'a'*51 }
    it { is_expected.not_to be_valid }
  end

  describe 'when last name to long' do
    before { @patient.last_name = 'a'*51 }
    it { is_expected.not_to be_valid }
  end

  describe 'when email is not present' do
    before { @patient.email = ' '}
      it { is_expected.not_to be_valid }
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
    it { is_expected.not_to be_valid }
  end

  describe 'password problems' do
    describe 'when password not present' do
      before {@patient.password = @patient.password_confirmation = ''}
      it { is_expected.not_to be_valid }
    end

    describe 'when password != password confirmation' do
      before do
        @patient.password = 'Qwerty1'
        @patient.password='YtrewQ1'
      end
      it { is_expected.not_to be_valid }
    end

    describe 'when password to short' do
      before { @patient.password = @patient.password_confirmation = 'Qwer1' }
      it { is_expected.not_to be_valid }
    end

    describe 'when password has no capital letters' do
      before { @patient.password = @patient.password_confirmation = 'qwerty1' }
      it { is_expected.not_to be_valid }
    end

    describe 'when password is all capital' do
      before { @patient.password = @patient.password_confirmation = 'QWERTY1' }
      it { is_expected.not_to be_valid }
    end

    describe 'when password has no numbers' do
      before { @patient.password = @patient.password_confirmation = 'Qwertyy' }
      it { is_expected.not_to be_valid }
    end
  end

  describe 'authentication method' do
    before { @patient.save }
    let(:found_patient) { Patient.find_by(email: @patient.email) }

    describe 'with valid password' do
      it { is_expected.to eq found_patient.authenticate(@patient.password) }
    end

    describe 'with invalid password' do
      let(:patient_invalid_password) { found_patient.authenticate('invalid') }
      it { is_expected.not_to eq patient_invalid_password }
      specify { expect(patient_invalid_password).to be_falsey }
    end

    describe 'remmeber token' do
      before { @patient.save }

      describe '#remember_token' do
        subject { super().remember_token }
        it { is_expected.not_to be_blank }
      end
    end
  end

  describe "Slug is set to patients name hyphenated" do
    before { @patient.save }

    describe '#slug' do
      subject { super().slug }
      it { is_expected.to eq "#{@patient.first_name.downcase}-#{@patient.last_name.downcase}" }
    end

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
      it(@patient)  { is_expected.to be_valid }
      it(@patient2) { is_expected.to be_valid }

      describe '#slug should have a unique number at the end' do
        it do
          expect(@patient.slug).to eq @patient.full_name.parameterize
          expect(@patient2.slug).to eq "#{@patient.slug}-1"
        end
      end
    end
  end

  describe 'with no state' do
    before { @patient.state = nil }
    it { is_expected.not_to be_valid }
  end
  describe 'State should only accept 2 char abbreviation' do
    before { @patient.state = 'Arizona' }
    it { is_expected.not_to be_valid }
  end

  describe 'social security number should be less than 12 digits' do
    before { @patient.social_security_number = '1' * 12 }
    it { is_expected.not_to be_valid }
  end

  describe 'with no sex specified' do
    before { @patient.sex = nil }
    it { is_expected.not_to be_valid }
  end

  describe 'with no address1' do
    before { @patient.address1 = nil }
    it {is_expected.not_to be_valid}
  end

  describe 'with address1 over 100char' do
    before { @patient.address1 = 'a' * 101 }
    it { is_expected.not_to be_valid }
  end

  describe 'with no city' do
   before { @patient.city = nil }
    it { is_expected.not_to be_valid }
  end

  describe 'with city name over 50char' do
    before { @patient.city = 'a' * 51 }
    it { is_expected.not_to be_valid }
  end

  describe 'with no zipcode' do
    before { @patient.zipcode = nil }
    it {is_expected.not_to be_valid}
  end

  describe 'with address1 over 11char' do
    before { @patient.zipcode = 'a' * 12 }
    it { is_expected.not_to be_valid }
  end

  describe 'with middle initial over 1char' do
    before { @patient.middle_initial = 'a' * 2 }
    it { is_expected.not_to be_valid }
  end

  describe 'with no birthday' do
    before { @patient.birthday =nil }
    it { is_expected.not_to be_valid }
  end

  describe 'with birthday in future' do
    before { @patient.birthday = Date.today + 3.days }
    it { is_expected.not_to be_valid }
  end
end
