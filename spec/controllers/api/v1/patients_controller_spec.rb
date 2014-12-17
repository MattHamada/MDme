require 'spec_helper'
include ApiHelpers

describe Api::V1::PatientsController do
  render_views
  let(:patient) { FactoryGirl.build(:patient) }
  before :each do
    @token = 'ca76c7a6c7a'
    patient.update_attribute(:api_key, my_encrypt(@token))
  end
  context :json do
    describe 'PATCH #update' do
      it 'should have failed response with no api token' do
        patch :update, format: 'json'
        expect(response).not_to be_success
        response.status.should == 401
        expect(json['success']).to eq false
      end
      it 'should have failed response with invalid api token' do
        config = { format: 'json', api_token: 123 }
        patch :update, config
        expect(response).not_to be_success
        response.status.should == 401
        expect(json['success']).to eq false
      end
      it 'should update patient with valid api token and valid attributes' do
        config = { format: 'json', api_token: @token, patient: {first_name: 'bill'} }
        patch :update, config
        expect(response).to be_success
        expect(json['success']).to eq true
        expect(patient.reload.first_name).to eq 'bill'
      end
      it 'should not update with valid api token and invalid attributes' do
        config = { format: 'json', api_token: @token, patient: {first_name: ''} }
        patch :update, config
        response.status.should == 202
        expect(json['success']).to eq false
      end
    end
    describe 'GET #index' do
      get_bad_requests :index
      it 'should respond successfully with proper API token' do
        config = { format: 'json', api_token: @token }
        get :index,  config
        expect(response).to be_success
        expect(json['success']).to eq true
        expect(json['info']).to eq 'Logged in'
        expect(json['data'].keys.include?('tasks'))
      end
    end
  end

  describe 'GET #show' do
    get_bad_requests :show
    it 'should respond successfully with proper API token' do
      config = { format: 'json', id: patient.slug, api_token: @token }
      get :show, config
      expect(response).to be_success
      expect(json['success']).to eq true
      expect(json['info']).to eq 'Profile'
      expect(json['data'].keys.include?('patient'))
      expect(json['data']['patient'].keys.include?('first_name'))
    end
  end
end
