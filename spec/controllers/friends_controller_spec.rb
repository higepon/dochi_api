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

        # friend user matcher
      end
    end
  end
end
