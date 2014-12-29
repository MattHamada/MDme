require 'spec_helper'

describe Api::V1::SessionsController do

  describe 'POST #create' do
     describe 'with invalid paramters'do
       it 'should return a failed response' do
         post :create, patient: {email: 'user@test.com', password: 'Qwerty1'}
         expect(response).not_to be_success
         expect(response.body).to eq(%({"success":false,"info":"Login failed","data":{}}))
       end
     end
    describe 'with valid parameters' do
      let(:patient) { FactoryGirl.build(:patient) }
      before do
        patient.save
      end
      it  'should return a valid response' do
        post :create, patient: {email: patient.email, password: patient.password}
        expect(response).to be_success
        expect(json['success']).to eq true
        expect(json['info']).to eq 'Logged in'
        expect(json['data']['api_token']).not_to be_nil
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:patient) { FactoryGirl.build(:patient) }
    before :each do
      patient.save
      post :create, patient: {email: patient.email, password: patient.password}
      @api_token = json['data']['api_token']
    end
    it 'should return a failed response with no api key' do
      delete :destroy
      expect(response).not_to be_success
    end
    it 'should return a failed response when api key invalid' do
      delete :destroy, {auth_token: '12355'}
      expect(response).not_to be_success
    end
    it 'should return a successfull response when api key valid' do
      delete :destroy, {auth_token: @api_token}
      expect(response).to be_success
    end
  end
end