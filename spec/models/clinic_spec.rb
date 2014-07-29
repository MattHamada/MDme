require 'spec_helper'

describe Clinic do
  before { @clinic = Clinic.new(name:         'Hospital',
                                address1:     'Scheduling Office',
                                address2:     '55 fruit street',
                                address3:     'Room 121',
                                city:         'Boston',
                                state:        'Massachusetts',
                                zipcode:      '02114',
                                country:      'United States',
                                phone_number: '617-726-2000',
                                fax_number:   '617-726-3000') }
  subject { @clinic }

  it { should respond_to :name }
  it { should respond_to :address1 }
  it { should respond_to :address2 }
  it { should respond_to :address3 }
  it { should respond_to :city }
  it { should respond_to :state }
  it { should respond_to :zipcode }
  it { should respond_to :country }
  it { should respond_to :phone_number }
  it { should respond_to :fax_number }

  it { should be_valid }
end
