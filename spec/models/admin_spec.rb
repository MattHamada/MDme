require 'spec_helper'

describe Admin do
  before { @admin = Admin.new(email: 'admin@example.com', password: 'foobar', password_confirmation: 'foobar') }

  subject { @admin }

  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
end
