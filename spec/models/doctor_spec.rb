require 'spec_helper'

describe Doctor do
  before { @doctor = Doctor.new(first_name: "Example", last_name: 'Doctor', email: "user@example.com", password: 'foobar', password_confirmation: 'foobar') }

  subject { @doctor }

  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:remember_token) }



end
