require 'spec_helper'

describe AppointmentsController do
  let(:clinic) { FactoryGirl.build(:clinic) }
  let(:patient) { FactoryGirl.create(:patient, clinics: [clinic]) }
  let(:doctors) { FactoryGirl.create(:doctors) }
  let(:appointment) { FactoryGirl.create(:appointment) }
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
    clinic.save
    doctor.save
    patient.save
    appointment.save
  end
  describe 'GET #fill_appointment' do
    it 'should not update the appointment time with an invalid access_key' do
      config = { access_key: 123, id: appointment.id }
      expect do
        get :fill_appointment, config
        appointment.reload
      end.not_to change(appointment, :appointment_time)
    end
    it 'should not change time if user declines offer' do
      config = { access_key: appointment.access_key,
                 id: appointment.id,
                 fill: 'false',
                 new_time: DateTime.now + 3.days }
      expect do
        get :fill_appointment, config
        appointment.reload
      end.not_to change(appointment, :appointment_time)
    end
    it 'should update appointment time with valid access_key' do
      config = { access_key: appointment.access_key,
                 id: appointment.id,
                 fill: 'true',
                 new_time: DateTime.now + 3.days }
      expect do
        get :fill_appointment, config
        appointment.reload
      end.to change(appointment, :appointment_time)
    end
  end
end
