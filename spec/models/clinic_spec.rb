require 'spec_helper'

describe Clinic do
  before { @clinic = Clinic.new(name: 'Hospital') }
  subject { @clinic }

  it { should respond_to :name }
  it { should be_valid }
end
