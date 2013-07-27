require 'spec_helper'

describe LoginController do

  it "facebook returns facebook user object" do
    request.accept = "application/json"
    post :facebook, { :token => 'dummy' }
    response.should be_success
    response.body.should have_json_path("name")
  end

  it "facebook returns error if token is not specified" do
    request.accept = "application/json"
    post :facebook
    response.response_code.should == 400
  end
end
