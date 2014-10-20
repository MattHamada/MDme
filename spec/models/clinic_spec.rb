require 'spec_helper'

describe Clinic do
  before { @clinic = Clinic.new(name:         'Hospital',
                                address1:     'Scheduling Office',
                                address2:     '55 fruit street',
                                address3:     'Room 121',
                                city:         'Boston',
                                state:        'Massachusetts',
                                zipcode:      '02114',
                                country:      'United States',
                                phone_number: '617-726-2000',
                                fax_number:   '617-726-3000') }
  subject { @clinic }

  it { should respond_to :name }
  it { should respond_to :address1 }
  it { should respond_to :address2 }
  it { should respond_to :address3 }
  it { should respond_to :city }
  it { should respond_to :state }
  it { should respond_to :zipcode }
  it { should respond_to :country }
  it { should respond_to :phone_number }
  it { should respond_to :fax_number }
  it { should respond_to :ne_latitude }
  it { should respond_to :ne_longitude }
  it { should respond_to :sw_latitude }
  it { should respond_to :sw_longitude }
  it { should be_valid }

  describe '#set_location_coordinates' do
    #comment out stub to call real api
    before do
      @clinic.stub(:call_google_api_for_location).and_return(
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
    end
    it 'should be called on model save' do
        @clinic.save
        @clinic.ne_latitude.round(4).should eq 42.3646
        @clinic.sw_latitude.round(4).should eq 42.3619
        @clinic.ne_longitude.round(4).should eq -71.0673
        @clinic.sw_longitude.round(4).should eq -71.0700
    end
    it 'should assign coordinates to the model' do
      @clinic.set_location_coordinates
      @clinic.ne_latitude.round(4).should eq 42.3646
      @clinic.sw_latitude.round(4).should eq 42.3619
      @clinic.ne_longitude.round(4).should eq -71.0673
      @clinic.sw_longitude.round(4).should eq -71.0700

    end
  end
end
