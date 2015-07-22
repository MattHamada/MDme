require 'spec_helper'
include ApiHelpers

describe Api::V1::Patients::ClinicsController do
  render_views
  let(:patient)              { FactoryGirl.build(:patient) }
  let(:doctors)               { FactoryGirl.create(:doctors) }
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
    patient.clinics << clinic
  end

  describe 'GET #index' do
    get_bad_requests :index
    it 'should respond successfully with proper API token' do
      config = { format: 'json', api_token: @token }
      get :index,  config
      expect(response).to be_success
      expect(json['success']).to eq true
      expect(json['info']).to eq "Patient's Clinics"
      expect(json['data'].keys.include?('clinics'))
    end
  end
end
