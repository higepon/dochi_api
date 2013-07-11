require 'spec_helper'

describe DecksController do

  it "create deck" do
    request.accept = "application/json"
    post :create
    response.should be_success
    response.body.should have_json_path("id")
  end

  it "index shows it's photo urls" do
    request.accept = "application/json"
    get :index
    response.should be_success
    response.body.should have_json_type(Array).at_path("0/photos")
    response.body.should have_json_type(String).at_path("0/photos/0/url")
  end

end
