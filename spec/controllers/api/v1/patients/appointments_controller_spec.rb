# MDme Rails master application
# Author:: Matt Hamada (maito:mattahamada@gmail.com)
# 4/11/14
# Copyright:: Copyright (c) 2014 MDme
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential.

require 'spec_helper'
include ApiHelpers

describe Api::V1::Patients::AppointmentsController do
  render_views
  let(:patient)              { FactoryGirl.build(:patient) }
  let(:doctor)               { FactoryGirl.create(:doctor) }
  let(:appointment)          { FactoryGirl.create(:appointment) }
  let(:appointment_request)  { FactoryGirl.create(:appointment_request) }
  let(:clinic)               { FactoryGirl.build(:clinic) }
  before do
    #comment out stub to call real api
    allow(clinic).to receive(:call_google_api_for_location).and_return(
        {
            "results" => [
                {
                    "address_components" => [
                        {
                            "long_name" => "55",
                            "short_name" => "55",
                            "types" => [ "street_number" ]
                        },
                        {
                            "long_name" => "Fruit Street",
                            "short_name" => "Fruit St",
                            "types" => [ "route" ]
                        },
                        {
                            "long_name" => "West End",
                            "short_name" => "West End",
                            "types" => [ "neighborhood", "political" ]
                        },
                        {
                            "long_name" => "Boston",
                            "short_name" => "Boston",
                            "types" => [ "locality", "political" ]
                        },
                        {
                            "long_name" => "Suffolk County",
                            "short_name" => "Suffolk County",
                            "types" => [ "administrative_area_level_2", "political" ]
                        },
                        {
                            "long_name" => "Massachusetts",
                            "short_name" => "MA",
                            "types" => [ "administrative_area_level_1", "political" ]
                        },
                        {
                            "long_name" => "United States",
                            "short_name" => "US",
                            "types" => [ "country", "political" ]
                        },
                        {
                            "long_name" => "02114",
                            "short_name" => "02114",
                            "types" => [ "postal_code" ]
                        }
                    ],
                    "formatted_address" => "55 Fruit Street, Boston, MA 02114, USA",
                    "geometry" => {
                        "location" => {
                            "lat" => 42.3632091,
                            "lng" => -71.0686487
                        },
                        "location_type" => "ROOFTOP",
                        "viewport" => {
                            "northeast" => {
                                "lat" => 42.3645580802915,
                                "lng" => -71.0672997197085
                            },
                            "southwest" => {
                                "lat" => 42.3618601197085,
                                "lng" => -71.06999768029151
                            }
                        }
                    },
                    "types" => [ "street_address" ]
                }
            ],
            "status" => "OK"
        }.to_json
    )
    clinic.save!
  end
  before :each do
    @token = 'ca76c7a6c7a'
    patient.update_attribute(:api_key, my_encrypt(@token))
  end

  describe 'GET #index' do
    get_bad_requests :index
    it 'should respond with a json array of tasks with valid api token' do
      config = { format: 'json', api_token: @token }
      get :index, config
      expect(response).to be_success
      expect(json['data']['tasks']).not_to be_empty
      expect(json['data']['tasks'][0]['title']).to eq 'Confirmed Appointments'
      expect(json['data']['tasks'][1]['title']).to eq 'Open Requests'
      expect(json['data']['tasks'][2]['title']).to eq 'New Request'
    end
  end

  describe 'GET #show' do
    get_bad_requests :show,  {id: 1}
    before do
      clinic.save
      doctor.save
      appointment.save
    end
    it 'should respond with json of appointment info with valid api token' do
      config = { format: 'json', api_token: @token, id: appointment.id }
      get :show, config
      expect(response).to be_success
      expect(json['data']['appointment']).not_to be_empty
      expect(json['data']['appointment']['date']).to eq appointment.date

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
      expect(json[:success]).to be_falsey
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
      expect(json['success']).to be_truthy
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
      expect(json[:success]).to be_falsey
    end
    it 'should give a success response with appointment time in past date' do
      config = { id: appointment.id,
                 api_token: @token,
                 appointment:
                     { appointment_time: DateTime.now + 1.day
                     }
      }
      patch :update, config
      expect(json['success']).to be_truthy
      expect(json['info']).to eq 'Appointment request updated'
    end
  end
end
