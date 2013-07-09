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

  it "can upload a photo" do
    request.accept = "application/json"
    post :create, :photo => { :photo_image => @file, :name => 'keiko', :deck_id => 1 }
    response.should be_success
    response.body.should be_json_eql(%({"status":"ok"}))
  end

end
