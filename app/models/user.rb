class User < ActiveRecord::Base
  attr_accessible :name

  def self.fb_user_by_token(token)
    graph = Koala::Facebook::API.new(token)
    graph.get_object("me")
  end
end
