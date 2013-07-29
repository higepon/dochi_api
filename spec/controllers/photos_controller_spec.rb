require 'spec_helper'

describe PhotosController do

  before do
    @file =  Rack::Test::UploadedFile.new('spec/fixtures/keiko.jpg', 'image/jpg')
  end

  it "should get index" do
    request.accept = "application/json"
    get 'index', { :user_id => 1234, :secret => 'abc' }
    response.should be_success
  end

  it "can upload two photos" do
    request.accept = "application/json"
    post :create, :user_id => 1234, :secret => 'abc', :photo0 => { :photo_image => @file, :name => 'saeko', :deck_id => 1 }, :photo1 => { :photo_image => @file, :name => 'jun', :deck_id => 2 }
    response.should be_success
    response.body.should be_json_eql(%({"status":"ok"}))
    Photo.find_by_name("saeko").should_not be_nil
    Photo.find_by_name("jun").should_not be_nil
  end

  it "can't upload two photos if user_is not specified" do
    request.accept = "application/json"
    post :create, :photo0 => { :photo_image => @file, :name => 'saeko', :deck_id => 1 }, :photo1 => { :photo_image => @file, :name => 'jun', :deck_id => 2 }
    response.response_code.should == 403
  end


  it "raise error when deck_id is not specified" do
    request.accept = "application/json"
    post :create, { :user_id => 1234, :secret => 'abc' }, :photo0 => { :photo_image => @file, :name => 'kaori'}, :photo1 => { :photo_image => @file, :name => 'aya', :deck_id => 2 }
    response.response_code.should == 400
    response.body.should be_json_eql(%({"status":"error"}))
    Photo.find_by_name("kaori").should be_nil
    Photo.find_by_name("aya").should be_nil
  end

end
