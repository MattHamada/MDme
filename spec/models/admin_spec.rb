require 'spec_helper'

describe Admin do
  before { @admin = Admin.new(email: 'admin@example.com',
                              password: 'Qwerty1',
                              password_confirmation: 'Qwerty1',
                              clinic_id: 1) }

  subject { @admin }

  it { is_expected.to respond_to(:email) }
  it { is_expected.to respond_to(:password_digest) }
  it { is_expected.to be_valid }
end
