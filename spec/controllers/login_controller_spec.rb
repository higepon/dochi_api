require 'spec_helper'

describe LoginController do
  fixtures :users
  before do
    VCR.configure do |c|
      c.cassette_library_dir = 'fixtures/vcr_cassettes'
      c.hook_into :webmock
    end
  end

  it "/facebook returns user object" do
    request.accept = "application/json"
    VCR.use_cassette('facebook') do
      post :facebook, { :token => 'test_token' }
    end
    response.should be_success
    response.body.should have_json_path("name")
    response.body.should have_json_path("email")
    response.body.should have_json_path("secret")
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

  it "/facebook create & returns new user" do
    request.accept = "application/json"
    num_user = User.all.count
    VCR.use_cassette('facebook') do
      post :facebook, { :token => 'test_token' }
    end
    response.should be_success
    user = JSON.parse(response.body)
    user["fb_id"].should == "649065487"
    user["email"].should == "taro@gmail.com"
    user["email"].should == "taro@gmail.com"
    User.all.count.should == num_user + 1
  end

  it "/facebook set fb_id to existing user if it doesn't have it" do
    request.accept = "application/json"
    User.find_by_email("john@gmail.com").fb_id.should be_nil
    VCR.use_cassette('facebook2') do
      post :facebook, { :token => 'test_token2' }
    end
    response.should be_success
    user = JSON.parse(response.body)
    User.find_by_email("john@gmail.com").fb_id.should_not be_nil
    user["fb_id"].should == "649065489"
    user["email"].should == "john@gmail.com"
    user["secret"].should_not be_nil
  end

  it "/facebook returns error if token is invalid" do
    request.accept = "application/json"
    VCR.use_cassette('facebook_invalid') do
      post :facebook, { :token => 'invalid_token' }
    end
    response.response_code.should == 400
  end

end
