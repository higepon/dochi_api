require 'spec_helper'

describe LoginController do
  fixtures :users
  before do
    VCR.configure do |c|
      c.cassette_library_dir = 'fixtures/vcr_cassettes'
      c.hook_into :webmock
    end
  end

  it "/facebook returns facebook user object" do
    request.accept = "application/json"
    VCR.use_cassette('facebook') do
      post :facebook, { :token => 'test_token' }
    end
    response.should be_success
    response.body.should have_json_path("name")
    response.body.should have_json_path("email")
  end

  it "/facebook returns error if token is not specified" do
    request.accept = "application/json"
    post :facebook
    response.response_code.should == 400
  end

  it "/facebook returns existing user if match" do
    request.accept = "application/json"
    VCR.use_cassette('facebook_existing_user') do
      post :facebook, { :token => 'existing_user_token' }
    end
    response.should be_success
    user = JSON.parse(response.body)
    user["id"].should equal 1234
  end
end
