module ApiHelpers

  def get_bad_requests(action, config = {})
    it 'should have failed response with no api token' do
      config[:format] = 'json'
      get action, config
      expect(response).not_to be_success
      response.status.should == 401
      expect(json['success']).to eq false
    end
    it 'should have failed response with invalid api token' do
      config[:format] = 'json'
      config[:api_token] = 123
      get action, config
      expect(response).not_to be_success
      response.status.should == 401
      expect(json['success']).to eq false
    end
  end

end