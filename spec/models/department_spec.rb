require 'spec_helper'

describe Department do
  before { @department = Department.new(name: 'Oncology') }
  subject { @department }

  it { is_expected.to respond_to :name }
  it { is_expected.to be_valid }
end
