require 'spec_helper'

describe Admin do
  before { @admin = Admin.new(email: 'admin@example.com',
                              password: 'Qwerty1',
                              password_confirmation: 'Qwerty1',
                              clinic_id: 1) }

  subject { @admin }

  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should be_valid }
end
