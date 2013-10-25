require 'spec_helper'

describe Photo do
  describe "#photo_image.process(:append)" do
    it "should merge two images and return it" do
      image = Photo.all[0].photo_image
      # just want to check, it doesn't raise.
      merged = image.process(:append, Photo.all[0].id, Photo.all[1])
    end
  end
end
