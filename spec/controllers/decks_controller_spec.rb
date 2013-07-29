require 'spec_helper'

describe DecksController do

  it "create deck" do
    request.accept = "application/json"
    post :create, { :user_id => 1234, :secret => 'abc' }
    response.should be_success
    response.body.should have_json_path("id")
  end

  it "/create returns error if user_is not specified" do
    request.accept = "application/json"
    post :create
    response.response_code.should == 403
  end

  it "index shows it's photo urls" do
    request.accept = "application/json"
    get :index, { :user_id => 1234, :secret => 'abc' }
    response.should be_success
    response.body.should have_json_type(Array).at_path("0/photos")
    response.body.should have_json_type(Integer).at_path("0/user_id")
    response.body.should have_json_type(String).at_path("0/user_name")
    response.body.should have_json_type(String).at_path("0/photos/0/url")
  end

end
