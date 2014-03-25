require 'spec_helper'

describe Doctor do
  before { @doctor = Doctor.new(first_name: 'Example',
                                last_name: 'Doctor',
                                email: 'user@example.com',
                                password: 'Foobar1',
                                password_confirmation: 'Foobar1',
                                clinic_id: 1) }

  subject { @doctor }

  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:department)}
  it { should respond_to(:patients)}
  it { should respond_to(:appointments)}
  it { should respond_to(:slug) }
  it { should be_valid }



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
      before { @doctor = Doctor.new(first_name: 'boo',
                                    last_name: 'radley',
                                    email: 'boo@radley.com',
                                    password: ' ',
                                    password_confirmation: ' ',
                                    clinic_id: 1) }

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

  describe "slug is set to doctor's name hyphenated" do
    before { @doctor.save }
    its(:slug) { should eq "#{@doctor.first_name.downcase}-#{@doctor.last_name.downcase}" }
  end

  describe 'A second doctor with the same name is still valid' do
    before do
      @doctor2 = @doctor.dup
      @doctor.save
      @doctor2.email = 'newEmail@email.com'
      @doctor2.save
    end
    it(@doctor)  { should be_valid }
    it(@doctor2) { should be_valid }
    its 'slug should have a unique number at the end' do
      @doctor.slug.should eq @doctor.full_name.parameterize
      @doctor2.slug.should eq "#{@doctor.slug}-1"
    end
  end

  describe 'updating doctor as admin bypasses password validation' do
    describe 'without admin set' do
      before do
        @doctor.password = 'a'
        @doctor.password_confirmation = 'a'
      end
      it { should_not be_valid }
    end

    describe 'with admin set' do
      before do
        @doctor.save!
        @doctor.password = 'a'
        @doctor.password_confirmation = 'a'
        @doctor.is_admin_applying_update = true
      end
      it { should be_valid }
    end

  end



end
