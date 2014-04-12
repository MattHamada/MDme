require 'spec_helper'
include ApiHelpers

describe Api::V1::Patients::AppointmentsController do
  render_views
  let(:patient)      { FactoryGirl.build(:patient) }
  let(:appointment)  { FactoryGirl.create(:appointment) }
  let(:appointment_request)  { FactoryGirl.create(:appointment_request) }

  before :each do
    @token = 'ca76c7a6c7a'
    patient.update_attribute(:api_key, encrypt(@token))
  end

  context :json do
    describe 'GET #tasks' do
      get_bad_requests(:tasks)
      it 'should respond with a json array of tasks with valid api token' do
        config = { format: 'json', api_token: @token }
        get :tasks, config
        expect(response).to be_success
        expect(json['data']['tasks']).not_to be_empty
        expect(json['data']['tasks'][0]['title']).to eq 'Confirmed Appointments'
        expect(json['data']['tasks'][1]['title']).to eq 'New Request'
        expect(json['data']['tasks'][2]['title']).to eq 'Open Requests'
      end
    end


  end
end
