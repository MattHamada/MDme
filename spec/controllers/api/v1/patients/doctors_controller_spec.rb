require 'spec_helper'
include ApiHelpers

describe Api::V1::Patients::DoctorsController do
  render_views
  let(:patient)      { FactoryGirl.build(:patient) }
  let(:department)   { FactoryGirl.build(:department) }
  let(:department2)  { FactoryGirl.build(:department, name: 'Genetics') }
  let(:department3)  { FactoryGirl.build(:department, clinic_id: 2) }
  let(:doctor)       { FactoryGirl.build(:doctor) }
  let(:doctor2)      { FactoryGirl.build(:doctor, email: 'doc2@doc.com') }
  let(:doctor3)      { FactoryGirl.build(:doctor, email: 'doc3@doc.com', clinic_id: 2) }
  let(:doctor4)      { FactoryGirl.build(:doctor, email: 'doc4@doc.com', department_id: 2)}
  before :each do
    department.save
    department2.save
    department3.save
    doctor.save
    doctor2.save
    doctor3.save
    doctor4.save
    @token = 'ca76c7a6c7a'
    patient.update_attribute(:api_key, my_encrypt(@token))
  end
  context :json do
    #needs to specify which clinic in request
    # describe 'GET department_index' do
    #   get_bad_requests(:department_index)
    #   it 'should return a list of departments in clinic with valid api token' do
    #     config = { format: 'json', api_token: @token }
    #     get :department_index, config
    #     expect(response).to be_success
    #     response.status.should == 200
    #     expect(json['data']['departments']).not_to be_nil
    #     expect(json['data']['departments'].find { |dept| dept['id'] == department.id}).to_not be_nil
    #     expect(json['data']['departments'].find { |dept| dept['id'] == department2.id}).to_not be_nil
    #     expect(json['data']['departments'].find { |dept| dept['id'] == department3.id}).to be_nil
    #   end
    # end

    #needs to specify which clinic in request
    # describe 'GET #index' do
    #   get_bad_requests(:index)
    #   it 'should return doctors in same department within same clinic' do
    #     config = { format: 'json', api_token: @token, name: department.name }
    #     get :index, config
    #     expect(response).to be_success
    #     expect(json['data']['doctors'].find { |doc| doc['id'] == doctor.id  }).not_to be_nil
    #     expect(json['data']['doctors'].find { |doc| doc['id'] == doctor2.id }).not_to be_nil
    #     expect(json['data']['doctors'].find { |doc| doc['id'] == doctor3.id }).to be_nil
    #     expect(json['data']['doctors'].find { |doc| doc['id'] == doctor4.id }).to be_nil
    #   end
    # end

    describe 'GET #show' do
      get_bad_requests :show, { id: 1 }
      it 'should return doctors info with valid api and valid id' do
        config = { format: 'json', api_token: @token, id: doctor.id }
        get :show, config
        expect(response).to be_success
        expect(json['data']['doctor']).not_to be_nil
        expect(json['data']['doctor']['full_name']).to eq doctor.full_name
        expect(json['data']['doctor']['description']).to eq doctor.description
        expect(json['data']['doctor']['education']).to eq doctor.education
        expect(json['data']['doctor']['department_name']).to eq doctor.department_name
        expect(json['data']['doctor']['avatar_medium_url']).not_to be_nil
      end
      it 'should have have invalid info valid api and invalid doctor id' do
        config = { format: 'json', api_token: @token, id: 999 }
        get :show, config
        expect(response).to be_success
        expect(json['info']).to eq 'Doctor not found.'
        expect(json['data']['doctor']).to be_nil
      end
    end
  end
end