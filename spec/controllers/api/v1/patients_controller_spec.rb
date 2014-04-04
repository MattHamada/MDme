require 'spec_helper'

describe Api::V1::PatientsController do
  let(:patient) { FactoryGirl.create(:patient) }
  before :each do
    patient.save
    @token = 'ca76c7a6c7a'
    patient.update_attribute(:remember_token, encrypt(@token))
  end
   describe 'GET #index' do
     it 'should respond successfully with proper API token' do
       get :index, {api_token: @token}
       expect(response).to be_success
       expect(json['success']).to eq true
       expect(json['info']).to eq 'Logged in'
       expect(json['data'].keys.include?('tasks'))
     end
     it 'should have failed response with no api token' do
       get :index
       expect(response).not_to be_success
       expect(json['success']).to eq false
     end
     it 'should have failed response with invalid api token' do
       get :index, {api_token: 123}
       expect(response).not_to be_success
       expect(json['success']).to eq false
     end
   end
end
