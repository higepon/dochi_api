require 'spec_helper'

describe PhotosController do

  before do
    @file =  Rack::Test::UploadedFile.new('spec/fixtures/keiko.jpg', 'image/jpg')
  end

  it "should get index" do
    request.accept = "application/json"
    get 'index'
    response.should be_success
  end

  it "can upload a license" do
    request.accept = "application/json"
    post :create, :upload => @file, :name => 'keiko'
    response.should be_success
    response.body.should have_json_type(Integer).at_path("id")
    response.body.should have_json_type(String).at_path("name")
    response.body.should have_json_type(String).at_path("photo_image_uid")
  end

end
