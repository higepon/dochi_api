require 'spec_helper'

describe DecksController do

  describe "#show" do
    it "should get show" do
      request.accept = "application/json"
      get 'show', { :user_id => 1234, :secret => 'abc', :id => 3 }
      response.should be_success
      body = response.body
      body.should have_json_type(Array).at_path("photos")
      body.should have_json_type(Integer).at_path("user/id")
      body.should have_json_type(String).at_path("user/avatar_url")
      body.should have_json_type(String).at_path("user/name")
      body.should have_json_type(String).at_path("photos/0/url")
      body.should have_json_type(Array).at_path("photos/0/likes")
      body.should have_json_type(Integer).at_path("photos/1/likes/0/id")
      body.should have_json_type(Hash).at_path("photos/1/likes/0/user")
      body.should have_json_type(String).at_path("photos/1/likes/0/user/name")
      body.should have_json_type(Integer).at_path("photos/1/likes/0/user/id")
      body.should have_json_type(String).at_path("photos/1/likes/0/user/avatar_url")
      body.should_not have_json_path("photos/1/likes/0/user/secret")
    end
  end

  describe "#friend" do
    context "a friend of the user is specified" do
      it "should get decks of the friend" do
        request.accept = "application/json"
        get 'friend', { :user_id => 1234, :secret => 'abc', :id => 3, :friend_id => 1235}
        response.should be_success
        body = response.body
        body.should have_json_type(Array).at_path("0/photos")
        body.should have_json_type(Integer).at_path("0/user/id")
        body.should have_json_type(String).at_path("0/user/avatar_url")
        body.should have_json_type(String).at_path("0/user/name")
        body.should have_json_type(String).at_path("0/photos/0/url")
        body.should have_json_type(Array).at_path("0/photos/0/likes")
        body.should have_json_type(Integer).at_path("0/photos/0/likes/0/id")
        body.should have_json_type(Hash).at_path("0/photos/0/likes/0/user")
        body.should have_json_type(String).at_path("0/photos/0/likes/0/user/name")
        body.should have_json_type(Integer).at_path("0/photos/0/likes/0/user/id")
        body.should have_json_type(String).at_path("0/photos/0/likes/0/user/avatar_url")
        body.should_not have_json_path("0/photos/0/likes/0/user/secret")
        decks = JSON.parse(body)
        decks[0]["user"]["id"] = 1235
      end
    end
    context "not friend of the user is specified" do
      it "should return error" do
        request.accept = "application/json"
        get 'friend', { :user_id => 1234, :secret => 'abc', :id => 3, :friend_id => 1236}
        response.should be_success
      end
    end
  end

  it "create deck" do
    request.accept = "application/json"
    post :create, { :user_id => 1234, :secret => 'abc' }
    response.should be_success
    response.body.should have_json_path("id")
  end

  it "/create returns error if user_id is not specified" do
    request.accept = "application/json"
    post :create
    response.response_code.should == 403
  end

  it "index shows it's photo urls" do
    request.accept = "application/json"
    get :index, { :user_id => 1234, :secret => 'abc' }
    response.should be_success
    body = response.body
#    puts body
    body.should have_json_type(Array).at_path("0/photos")
    body.should have_json_type(Integer).at_path("0/user/id")
    body.should have_json_type(String).at_path("0/user/avatar_url")
    body.should have_json_type(String).at_path("0/user/name")
    body.should have_json_type(String).at_path("0/photos/0/url")
    body.should have_json_type(Array).at_path("0/photos/0/likes")
    body.should have_json_type(Integer).at_path("0/photos/0/likes/0/id")
    body.should have_json_type(Hash).at_path("0/photos/0/likes/0/user")
    body.should have_json_type(String).at_path("0/photos/0/likes/0/user/name")
    body.should have_json_type(Integer).at_path("0/photos/0/likes/0/user/id")
    body.should have_json_type(String).at_path("0/photos/0/likes/0/user/avatar_url")
    body.should_not have_json_path("0/photos/0/likes/0/user/secret")
  end

  it "index returns not_found" do
    request.accept = "application/json"
    get :index, { :user_id => 99999999, :secret => 'abc' }
    response.response_code.should == 404
  end
end
