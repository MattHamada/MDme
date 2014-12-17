# MDme Rails master application
# Author:: Matt Hamada (maito:mattahamada@gmail.com)
# 11/5/14
# Copyright:: Copyright (c) 2014 MDme
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential.

require 'spec_helper'
include ApiHelpers

describe Api::V1::Patients::DevicesController do
  render_views
  let(:patient)              { FactoryGirl.build(:patient) }
  let(:clinic)               { FactoryGirl.build(:clinic) }


  before do
    #comment out stub to call real api
    clinic.stub(:call_google_api_for_location).and_return(
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

  context :json do
    describe 'POST #create' do
      post_bad_requests :create
      it 'should have a successful response with valid inputs' do
        clinic.save
        patient.save
        config = { api_token: @token, device:
                                        {
                                            patient_id: patient.id,
                                            token: 'testToken123',
                                            platform: 'android'
                                        }
                }
        post :create, config
        expect(json['success']).to be_true
        expect(json['info']).to eq 'Device saved'
      end
    end
  end
end

