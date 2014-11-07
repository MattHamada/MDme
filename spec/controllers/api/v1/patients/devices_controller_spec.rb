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
  let(:clinic)               { FactoryGirl.create(:clinic) }

  before :each do
    @token = 'ca76c7a6c7a'
    patient.update_attribute(:api_key, encrypt(@token))
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

