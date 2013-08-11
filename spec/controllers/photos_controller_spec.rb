require 'spec_helper'

describe PhotosController do
  describe "index" do
    it "should get index" do
      request.accept = "application/json"
      get 'index', { :user_id => 1234, :secret => 'abc' }
      response.should be_success
    end
  end

  describe "like" do
    it "should like the photo and return photo as json" do
      request.accept = "application/json"
      post :like, :user_id => 1234, :secret => 'abc', :photo_id => 101
      response.should be_success
      body = response.body
      body.should have_json_type(Integer).at_path("id")
      body.should have_json_type(Array).at_path("likes")
      body.should have_json_type(Integer).at_path("likes/0/id")
      body.should have_json_type(Hash).at_path("likes/0/user")
      body.should have_json_type(String).at_path("likes/0/user/name")
      body.should have_json_type(String).at_path("likes/0/user/avatar_url")
      body.should_not have_json_path("likes/0/user/secret")
    end
  end

  describe "create" do
    before do
      @file =  Rack::Test::UploadedFile.new('spec/fixtures/keiko.jpg', 'image/jpg')
    end

    it "should upload two photos" do
      request.accept = "application/json"
      post :create, :user_id => 1234, :secret => 'abc', :photo0 => { :photo_image => @file, :name => 'saeko', :deck_id => 1 }, :photo1 => { :photo_image => @file, :name => 'jun', :deck_id => 2 }
      response.should be_success
      response.body.should be_json_eql(%({"status":"ok"}))
      Photo.find_by_name("saeko").should_not be_nil
      Photo.find_by_name("jun").should_not be_nil
    end
    context "when user_id not specified" do
      it "should not be able to upload two photos" do
        request.accept = "application/json"
        post :create, :photo0 => { :photo_image => @file, :name => 'saeko', :deck_id => 1 }, :photo1 => { :photo_image => @file, :name => 'jun', :deck_id => 2 }
        response.response_code.should == 403
      end
    end
    context "when deck_id not specified" do
      it "should raise error" do
        request.accept = "application/json"
        post :create, { :user_id => 1234, :secret => 'abc' }, :photo0 => { :photo_image => @file, :name => 'kaori'}, :photo1 => { :photo_image => @file, :name => 'aya', :deck_id => 2 }
        response.response_code.should == 400
        response.body.should be_json_eql(%({"status":"error"}))
        Photo.find_by_name("kaori").should be_nil
        Photo.find_by_name("aya").should be_nil
      end
    end
  end
end
