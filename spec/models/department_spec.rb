require 'spec_helper'

describe Department do
  before { @department = Department.new(name: 'Oncology') }
  subject { @department }

  it { should respond_to :name }
  it { should be_valid }
end
