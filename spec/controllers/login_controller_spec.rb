require 'spec_helper'

describe LoginController do

  it "facebook returns facebook user object" do
    request.accept = "application/json"
    post :facebook
    response.should be_success
    response.body.should have_json_path("name")
  end

end
