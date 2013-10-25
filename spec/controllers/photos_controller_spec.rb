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
    fixtures :likes, :photos
    it "should like the photo and return photo as json" do
      request.accept = "application/json"
      post :like, :user_id => 1234, :secret => 'abc', :photo_id => 100
      response.should be_success
      body = response.body
#      puts body
      body.should have_json_type(Integer).at_path("id")
      body.should have_json_type(Array).at_path("likes")
      body.should have_json_type(Integer).at_path("likes/0/id")
      body.should have_json_type(Hash).at_path("likes/0/user")
      body.should have_json_type(String).at_path("likes/0/user/name")
      body.should have_json_type(Integer).at_path("likes/0/user/id")
      body.should have_json_type(String).at_path("likes/0/user/avatar_url")
      body.should_not have_json_path("likes/0/user/secret")
    end

    context "when it has already liked" do
      it "should unlike it" do
        request.accept = "application/json"
        Like.where(:user_id => 1234, :photo_id => 101).should_not be_empty
        post :like, :user_id => 1234, :secret => 'abc', :photo_id => 101
        Like.where(:user_id => 1234, :photo_id => 101).should be_empty
      end
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
      body = response.body
      body.should have_json_type(String).at_path("status")
      body.should have_json_type(String).at_path("url")
      Photo.find_by_name("saeko").should_not be_nil
      Photo.find_by_name("jun").should_not be_nil
    end

    describe "push notifications" do
      fixtures :friends, :users, :devices
      it "should send push notification to friends" do
        request.accept = "application/json"
        post :create, :user_id => 1234, :secret => 'abc', :photo0 => { :photo_image => @file, :name => 'saeko', :deck_id => 2 }, :photo1 => { :photo_image => @file, :name => 'jun', :deck_id => 2 }
        response.should be_success
        creator = User.find(1234)
        friend = User.find(1235)
        device_token = friend.devices[0].token
        notification = Rapns::Apns::Notification.where(:device_token => device_token, :delivered => false).order('id desc').first
        notification.should_not be_nil
        notification.alert.should == "taro wants to check you new photos!"
        notification.attributes_for_device.should == {"deck_id" => 2}
        notification.delivered.should be_false
      end
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
