class User < ActiveRecord::Base
  attr_accessible :name, :email, :fb_id, :secret, :avatar_url
  has_many :devices
  has_many :_friends, class_name: "Friend",
                     foreign_key: "src_user_id"
  has_many :users, :source => :friend, :through => :_friends

  def self.fb_user_by_token(token)
    graph = Koala::Facebook::API.new(token)
    graph.get_object("me")
  end

  def friends
    _friends.map {|f| User.find(f.dest_user_id) }
  end

  def suggested_users
    friend_ids = _friends.map {|f| User.find(f.dest_user_id).id }
    order_fun = if Rails.env.development? then "rand()" else "random()" end
    if friend_ids.empty?
      User.where("id != ? and fb_id not like 'guest_%'", self.id).limit(5).order(order_fun)
    else
      User.where(["id NOT IN (?)  and fb_id not like 'guest_%'", friend_ids + [self.id]]).limit(5).order(order_fun)
    end
  end

  def like!(photo)
    like = Like.new(:photo_id => photo.id, :user_id => self.id)
    like.save
  rescue
    false
  end

  def unlike!(photo)
    like = Like.where(:photo_id => photo.id, :user_id => self.id).first
    like.destroy if like
  end
end
