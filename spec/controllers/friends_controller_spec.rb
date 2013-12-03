require 'spec_helper'

describe FriendsController do
  describe "#show" do
    context "when user is not specified" do
      it "return error" do
        request.accept = "application/json"
        post :show, :user_id => 100000, :secret => 'abc'
        response.should_not be_success
      end
    end

    context "when user is specified" do
      it "return a list of friends" do
        request.accept = "application/json"
        post :show, :user_id => 1234, :secret => 'abc'
        response.should be_success
        body = response.body
        body.should_not have_json_path("secret")
        body.should_not have_json_path("email")
        body.should_not have_json_path("fb_id")
        body.should have_json_type(String).at_path("name")
        body.should have_json_type(Integer).at_path("id")
        body.should have_json_type(String).at_path("avatar_url")

        body.should have_json_type(Array).at_path("friends")
        body.should have_json_type(Integer).at_path("friends/0/id")
        body.should have_json_type(String).at_path("friends/0/avatar_url")
        body.should have_json_type(String).at_path("friends/0/name")
        body.should_not have_json_path("friends/0/secret")
        body.should_not have_json_path("friends/0/email")
        body.should_not have_json_path("friends/0/fb_id")
        json = JSON.parse(response.body)
        friends = json["friends"]
        friends.size.should be 1
        friends[0]["id"] = 1235
      end
    end
  end

  describe "#suggestions" do
    context "when user is not specified" do
      it "return error" do
        request.accept = "application/json"
        post :suggestions, :user_id => 100000, :secret => 'abc'
        response.should_not be_success
      end
    end

    context "when user is specified" do
      it "return a list of suggested friends" do
        request.accept = "application/json"
        post :suggestions, :user_id => 1234, :secret => 'abc'
        response.should be_success
        body = response.body
        body.should have_json_type(Array).at_path("")
        body.should have_json_type(Integer).at_path("0/id")
        body.should have_json_type(String).at_path("0/avatar_url")
        body.should have_json_type(String).at_path("0/name")
        body.should_not have_json_path("friends/0/secret")
        body.should_not have_json_path("friends/0/email")
        body.should_not have_json_path("friends/0/fb_id")
        friends = JSON.parse(response.body)
        friends.size.should be 2
        friends[0]["id"] = 1235
        friends[1]["id"] = 1236
      end
    end
  end

end
