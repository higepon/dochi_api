class User < ActiveRecord::Base
  attr_accessible :name, :email, :fb_id, :secret, :avatar_url

  def self.fb_user_by_token(token)
    graph = Koala::Facebook::API.new(token)
    graph.get_object("me")
  end

  def like!(deck)
    like = Like.new(:deck_id => deck.id, :user_id => self.id)
    like.save
    like
  end
end
