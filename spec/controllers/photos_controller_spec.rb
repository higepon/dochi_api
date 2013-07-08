require 'spec_helper'

describe PhotosController do

  before do
    @file = fixture_file_upload('/keiko.jpg', 'image/jpg')
  end

  it "should get index" do
    request.accept = "application/json"
    get 'index'
    response.should be_success
  end

  it "can upload a license" do
    request.accept = "application/json"
    post :create, :upload => @file
    response.should be_success
  end
end
