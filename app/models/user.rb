class User < ActiveRecord::Base
  attr_accessible :name, :email, :fb_id, :secret, :avatar_url

  def self.fb_user_by_token(token)
    graph = Koala::Facebook::API.new(token)
    graph.get_object("me")
  end

  def like!(photo)
    like = Like.new(:photo_id => photo.id, :user_id => self.id)
    like.save
    like
  rescue 
    nil
  end

  def unlike!(deck)
    # like = Like.where(:deck_id => deck.id, :user_id => self.id).first
    # like.destroy if like
  end
end
