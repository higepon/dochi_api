require 'spec_helper'

describe DeviceController do
  describe "#update" do
    context "when unknown user is not specified" do
      it "return error" do
        post :update, :user_id => 100000, :secret => 'abc', :token => "new_token"
        response.should_not be_success
      end
    end

    context "when a token is not registerred yet" do
      it "register the token" do
        request.accept = "application/json"
        Device.where(:user_id => 1234, :token => "new_token").should be_empty
        post :update, :user_id => 1234, :secret => 'abc', :token => "new_token"
        devices = Device.where(:user_id => 1234, :token => "new_token")
        devices.should_not be_empty
        devices.size.should be 1
        response.should be_success
        response.body.should be_json_eql(%({"status":"ok"}))
      end
    end

    context "when a token is registerred" do
      it "keep it as it is" do
        request.accept = "application/json"
        Device.where(:user_id => 1234, :token => "known_token").size.should be 1
        post :update, :user_id => 1234, :secret => 'abc', :token => "know_token"
        devices = Device.where(:user_id => 1234, :token => "new_token")
        Device.where(:user_id => 1234, :token => "known_token").size.should be 1
        response.should be_success
        response.body.should be_json_eql(%({"status":"ok"}))
      end
    end
  end
end
