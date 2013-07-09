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
    Photo.find_by_name("keiko").should_not be_nil
  end

  it "can upload two photos" do
    request.accept = "application/json"
    post :create, :photo => { :photo_image => @file, :name => 'saeko', :deck_id => 1 }, :photo2 => { :photo_image => @file, :name => 'jun', :deck_id => 2 }
    response.should be_success
    response.body.should be_json_eql(%({"status":"ok"}))
    Photo.find_by_name("saeko").should_not be_nil
    Photo.find_by_name("jun").should_not be_nil
  end

end
