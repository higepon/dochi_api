class Photo < ActiveRecord::Base
  attr_accessible :name, :photo_image_uid, :photo_image
  image_accessor :photo_image
end
