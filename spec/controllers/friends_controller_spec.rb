require 'spec_helper'

describe FriendsController do
  describe "#show" do
    context "when user is not specified" do
      it "return error" do
        post :show, :user_id => 100000, :secret => 'abc'
        response.should_not be_success
      end
    end

    context "when user is specified" do
      it "return a list of friends" do
        post :show, :user_id => 1234, :secret => 'abc'
        response.should be_success
        body = response.body
        body.should have_json_type(Array).at_path("friends")
        body.should have_json_type(Integer).at_path("friends/0/id")
        body.should have_json_type(String).at_path("friends/0/avatar_url")
        body.should have_json_type(String).at_path("friends/0/name")
        body.should_not have_json_type(String).at_path("friends/0/secret")
        body.should_not have_json_type(String).at_path("friends/0/email")

        json = JSON.parse(response.body)
        friends = json["friends"]
        friends.size should equal 2
        friends[0]["id"] = 1235
        friends[1]["id"] = 1236
      end
    end
  end
end
