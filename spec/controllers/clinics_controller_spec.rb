require 'spec_helper'

describe ClinicsController do
  let(:clinic) { FactoryGirl.build(:clinic) }
  let(:doctor) { FactoryGirl.create(:doctor) }
  let(:patient) { FactoryGirl.create(:patient) }
  let(:appointment) { FactoryGirl.create(:appointment_today) }
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
    doctor.save!
    patient.save!
    appointment.save!
  end
  describe 'checking in' do
    it 'should check in patient' do
      params = {patient_id: patient.id, id: clinic.slug}
      get :checkin, params
      expect(appointment.reload.checked_in).to be_true
    end
  end
end
