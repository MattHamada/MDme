require 'spec_helper'
include ApiHelpers

describe Api::V1::Patients::ClinicsController do
  render_views
  let(:patient)              { FactoryGirl.build(:patient) }
  let(:doctor)               { FactoryGirl.create(:doctor) }
  let(:appointment)          { FactoryGirl.create(:appointment) }
  let(:appointment_request)  { FactoryGirl.create(:appointment_request) }
  let(:clinic)               { FactoryGirl.create(:clinic) }

  before :each do
    @token = 'ca76c7a6c7a'
    patient.update_attribute(:api_key, encrypt(@token))
    patient.clinics << clinic
  end

  context :json do
    describe 'GET #index' do
      get_bad_requests :index
      it 'should respond successfully with proper API token' do
        config = { format: 'json', api_token: @token }
        get :index,  config
        expect(response).to be_success
        expect(json['success']).to eq true
        expect(json['info']).to eq "Patient's Clinics"
        expect(json['data'].keys.include?('clinics'))
      end
    end
  end
end
