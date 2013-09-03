require 'spec_helper'

describe User do
 self.use_transactional_fixtures = true
  fixtures :users, :likes, :photos
  describe "#like!" do
    context "when it has not been liked yet" do
      it "should create and return new like" do
        not_liked_photo_id = 100
        photo = Photo.find(not_liked_photo_id)
        u = User.find(1234)
        un.like!(photo).should be_true
      end
    end
    context "when it has already been liked" do
      it "should return nil" do
        liked_photo_id = 101
        photo = Photo.find(liked_photo_id)
        user = User.find(1234)
        user.like!(photo).should be_false
      end
    end
  end
end
