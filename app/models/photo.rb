class Photo < ActiveRecord::Base
  belongs_to :deck
  attr_accessible :name, :photo_image_uid, :photo_image, :deck_id
  image_accessor :photo_image

  validate :deck_id_not_nil

  def deck_id_not_nil
   if self.deck_id.nil?
     errors.add :photo, 'cannot be nil'
   end
  end
end
