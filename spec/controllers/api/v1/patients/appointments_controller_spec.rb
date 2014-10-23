require 'spec_helper'
include ApiHelpers

describe Api::V1::Patients::AppointmentsController do
  render_views
  let(:patient)              { FactoryGirl.build(:patient) }
  let(:doctor)               { FactoryGirl.create(:doctor) }
  let(:appointment)          { FactoryGirl.create(:appointment) }
  let(:appointment_request)  { FactoryGirl.create(:appointment_request) }
  let(:clinic)               { FactoryGirl.create(:clinic) }

  before :each do
    @token = 'ca76c7a6c7a'
    patient.update_attribute(:api_key, encrypt(@token))
  end

  context :json do
    describe 'GET #index' do
      get_bad_requests :index
      it 'should respond with a json array of tasks with valid api token' do
        config = { format: 'json', api_token: @token }
        get :index, config
        expect(response).to be_success
        expect(json['data']['tasks']).not_to be_empty
        expect(json['data']['tasks'][0]['title']).to eq 'Confirmed Appointments'
        expect(json['data']['tasks'][1]['title']).to eq 'New Request'
        expect(json['data']['tasks'][2]['title']).to eq 'Open Requests'
      end
    end

    describe 'GET #confirmed_appointments' do
      before do
        doctor.save
        appointment.save
        appointment_request.save
      end
      get_bad_requests :confirmed_appointments
      it 'should respond with only upcomming confirmed appointments with valid request' do
        config = { format: 'json', api_token: @token }
        get :confirmed_appointments, config
        expect(response).to be_success
        puts json
        expect(json['data']['appointments']).not_to be_empty
        expect(json['data']['appointments'].find { |apt| apt['id'] == appointment.id }).not_to be_nil
        expect(json['data']['appointments'].find { |apt| apt['id'] == appointment_request.id }).to be_nil
      end
    end

    describe 'POST #create' do
      before do
        clinic.save
        doctor.save
      end
      post_bad_requests :create
      it 'should give a failed response with appointment time in past date' do
        config = { api_token: @token, appointment:
                                         { patient_id: patient.id,
                                           doctor_id:  doctor.id,
                                           appointment_time: DateTime.now - 1.day,
                                           clinic_id: clinic.id,
                                           description: 'im sick :('}
                }
        post :create, config
        expect(json[:success]).to be_false
      end
      it 'should give a successful response with valid inputs' do
        config = { api_token: @token, appointment:
                                        { patient_id: patient.id,
                                          doctor_id:  doctor.id,
                                          appointment_time: DateTime.now + 1.day,
                                          clinic_id: clinic.id,
                                          description: 'im sick :(' }
                }
        post :create, config
        expect(json['success']).to be_true
        expect(json['info']).to eq 'Appointment requested'
      end
    end

    describe 'POST #update' do
      before do
        clinic.save
        doctor.save
        appointment_request.save
      end
      patch_bad_requests :update, { id: 1 }
      it 'should give a failed response with appointment time in past date' do
        config = { id: appointment.id,
                   api_token: @token,
                   appointment:
                    { appointment_time: DateTime.now - 1.day
                    }
        }
        patch :update, config
        expect(json[:success]).to be_false
      end
      it 'should give a success response with appointment time in past date' do
        config = { id: appointment.id,
                   api_token: @token,
                   appointment:
                       { appointment_time: DateTime.now + 1.day
                       }
        }
        patch :update, config
        expect(json['success']).to be_true
        expect(json['info']).to eq 'Appointment request updated'
      end
    end
  end
end
