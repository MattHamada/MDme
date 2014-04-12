require 'spec_helper'

describe Api::V1::Patients::AppointmentsController do
  render_views
  let(:patient)      { FactoryGirl.build(:patient) }
  before :each do
    @token = 'ca76c7a6c7a'
    patient.update_attribute(:api_key, encrypt(@token))
  end

  context :json do
    describe 'GET #tasks' do
      it 'should have failed response with no api token' do
        get :tasks, format: 'json'
        expect(response).not_to be_success
        response.status.should == 401
        expect(json['success']).to eq false
      end
      it 'should have failed response with invalid api token' do
        config = { format: 'json', api_token: 123 }
        get :tasks, config
        expect(response).not_to be_success
        response.status.should == 401
        expect(json['success']).to eq false
      end
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

    describe 'GET #confirmed_appointments' do

    end
  end
end
