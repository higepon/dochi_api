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

  it "can upload two photos" do
    request.accept = "application/json"
    post :create, :photo => { :photo_image => @file, :name => 'saeko', :deck_id => 1 }, :photo2 => { :photo_image => @file, :name => 'jun', :deck_id => 2 }
    response.should be_success
    response.body.should be_json_eql(%({"status":"ok"}))
    Photo.find_by_name("saeko").should_not be_nil
    Photo.find_by_name("jun").should_not be_nil
  end

  it "raise error when deck_id is not specified" do
    request.accept = "application/json"
    post :create, :photo => { :photo_image => @file, :name => 'saeko'}, :photo2 => { :photo_image => @file, :name => 'jun', :deck_id => 2 }
    response.response_code.should == 400
    response.body.should be_json_eql(%({"status":"error"}))
    Photo.find_by_name("saeko").should be_nil
    Photo.find_by_name("jun").should be_nil
  end

end
