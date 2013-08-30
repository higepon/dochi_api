require 'spec_helper'

describe DecksController do

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
    puts body
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

  # describe "#like" do
  #   fixtures :likes, :decks
  #   it "like likes deck" do
  #   request.accept = "application/json"
  #   post :like, { :user_id => 1234, :secret => 'abc', :deck_id => 2}
  #   response.should be_success
  #   end
  # end
end
