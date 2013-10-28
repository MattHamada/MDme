require 'spec_helper'

describe User do
  before { @user = User.new(name: "Example User", email: "user@example.com", password: 'foobar', password_confirmation: 'foobar') }

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }

  it { should be_valid }

  describe 'when name is not present' do
    before { @user.name = ' ' }
    it { should_not be_valid }
  end

  describe 'when name to long' do
    before { @user.name = 'a'*51 }
    it { should_not be_valid }
  end

  describe 'when email is not present' do
    before { @user.email = ' '}
      it { should_not be_valid }
  end

  describe 'with valid email' do
    before { @user.email = 'test@test.com' }
    specify { expect(@user).to be_valid }
  end

  describe 'with invalid email ' do
    it 'should be invalid' do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com foo@bar..com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  describe 'when email already taken' do
    before do
      user_dup = @user.dup
      user_dup.email = user_dup.email.upcase
      user_dup.save
    end
    it { should_not be_valid }
  end

  describe 'when password not present' do
    before { @user = User.new(name: "Example User", email: "user@example.com", password: '', password_confirmation: '') }
    it { should_not be_valid }
  end

  describe 'when password != password confirmation' do
    before { @user = User.new(name: "Example User", email: "user@example.com", password: 'fizzbuzz', password_confirmation: 'foobar') }
    it { should_not be_valid }
  end

  describe 'when password to short' do
    before { @user.password = @user.password_confirmation = 'a'*5 }
    it { should_not be_valid }
  end

  describe 'authentication method' do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) }

    describe 'with valid password' do
      it { should eq found_user.authenticate(@user.password) }
    end

    describe 'with invalid password' do
      let(:user_invalid_password) { found_user.authenticate('invalid') }
      it { should_not eq user_invalid_password }
      specify { expect(user_invalid_password).to be_false }
    end
  end




end
