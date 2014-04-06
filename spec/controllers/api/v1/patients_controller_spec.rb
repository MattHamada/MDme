require 'spec_helper'

describe Api::V1::PatientsController do
  render_views
  let(:patient) { FactoryGirl.create(:patient) }
  before :each do
    patient.save
    @token = 'ca76c7a6c7a'
    patient.update_attribute(:remember_token, encrypt(@token))
  end
  context :json do
   describe 'GET #index' do
     it 'should respond successfully with proper API token' do
       config = { format: 'json', api_token: @token }
       get :index,  config
       expect(response).to be_success
       puts json
       expect(json['success']).to eq true
       expect(json['info']).to eq 'Logged in'
       expect(json['data'].keys.include?('tasks'))
     end
     it 'should have failed response with no api token' do
       get :index, format: 'json'
       expect(response).not_to be_success
       response.status.should == 401
       expect(json['success']).to eq false
     end
     it 'should have failed response with invalid api token' do
       config = { format: 'json', api_token: 123 }
       get :index, config
       expect(response).not_to be_success
       response.status.should == 401
       expect(json['success']).to eq false
     end
   end
   end

  describe 'GET #show' do
    it 'should have failed response with no api token' do
      config = { format: 'json', id: patient.slug }
      get :show, config
      expect(response).not_to be_success
      expect(json['success']).to eq false
    end
    it 'should have failed response with invalid api token' do
      config = { format: 'json', id: patient.slug, api_token: 123 }
      get :show,  config
      expect(response).not_to be_success
      expect(json['success']).to eq false
    end
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
