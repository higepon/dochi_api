require 'spec_helper'

describe DecksController do

  it "create deck" do
    request.accept = "application/json"
    post :create
    response.should be_success
  end

end
