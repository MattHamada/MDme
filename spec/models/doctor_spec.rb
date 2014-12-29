require 'spec_helper'

describe Doctor do
  before { @doctor = Doctor.new(first_name: 'Example',
                                last_name: 'Doctor',
                                email: 'user@example.com',
                                password: 'Foobar1',
                                password_confirmation: 'Foobar1',
                                clinic_id: 1) }

  subject { @doctor }

  it { is_expected.to respond_to(:first_name) }
  it { is_expected.to respond_to(:last_name) }
  it { is_expected.to respond_to(:email) }
  it { is_expected.to respond_to(:password_digest) }
  it { is_expected.to respond_to(:remember_token) }
  it { is_expected.to respond_to(:department)}
  it { is_expected.to respond_to(:patients)}
  it { is_expected.to respond_to(:appointments)}
  it { is_expected.to respond_to(:slug) }
  it { is_expected.to be_valid }



  describe 'creating a doctor' do
    describe 'invalid with missing first name' do
      before { @doctor.first_name = ' ' }
      it { is_expected.not_to be_valid }
    end

    describe 'invalid with missing last name' do
      before { @doctor.last_name = ' ' }
      it { is_expected.not_to be_valid }
    end

    describe 'invalid with missing email' do
      before { @doctor.email = ' ' }
      it { is_expected.not_to be_valid }
    end

    describe 'invalid with improper email format' do
      before { @doctor.email = '3/2x@xda.xac.p' }
      it { is_expected.not_to be_valid }
    end

    describe 'invalid with missing password' do
      before { @doctor = Doctor.new(first_name: 'boo',
                                    last_name: 'radley',
                                    email: 'boo@radley.com',
                                    password: ' ',
                                    password_confirmation: ' ',
                                    clinic_id: 1) }

      it { is_expected.not_to be_valid }
    end

    describe 'invalid with short password' do
      before { @doctor.password = '1234' }
      it { is_expected.not_to be_valid }
    end
  end

  describe 'full_name method returns first and last name' do
    before { @doctor.save }

    describe '#full_name' do
      subject { super().full_name }
      it { is_expected.to eq "#{@doctor.first_name} #{@doctor.last_name}" }
    end
  end

  describe "slug is set to doctor's name hyphenated" do
    before { @doctor.save }

    describe '#slug' do
      subject { super().slug }
      it { is_expected.to eq "#{@doctor.first_name.downcase}-#{@doctor.last_name.downcase}" }
    end
  end

  describe 'A second doctor with the same name is still valid' do
    before do
      @doctor2 = @doctor.dup
      @doctor.save
      @doctor2.email = 'newEmail@email.com'
      @doctor2.save
    end
    it(@doctor)  { is_expected.to be_valid }
    it(@doctor2) { is_expected.to be_valid }

    describe '#slug should have a unique number at the end' do
      it do
        expect(@doctor.slug).to eq @doctor.full_name.parameterize
        expect(@doctor2.slug).to eq "#{@doctor.slug}-1"
      end
    end
  end

  describe 'updating doctor as admin bypasses password validation' do
    describe 'without admin set' do
      before do
        @doctor.password = 'a'
        @doctor.password_confirmation = 'a'
      end
      it { is_expected.not_to be_valid }
    end

    describe 'with admin set' do
      before do
        @doctor.save!
        @doctor.password = 'a'
        @doctor.password_confirmation = 'a'
        @doctor.bypass_password_validation = true
      end
      it { is_expected.to be_valid }
    end

  end



end
