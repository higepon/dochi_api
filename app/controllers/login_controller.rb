class LoginController < ApplicationController

  skip_before_filter  :verify_authenticity_token

  def facebook
    if params[:token]
      graph = Koala::Facebook::API.new(params[:token])
      me = graph.get_object("me")
      existing_user = User.find_by_fb_id(me["id"])
      # user has already account with facebook
      if existing_user
        update_friends(existing_user, graph)
        render json: existing_user
      else
        # user has already account but not connected facebook
        same_email_user = User.find_by_email(me["email"])
        if same_email_user
          same_email_user.fb_id = me["id"]
          same_email_user.avatar_url = fb_avatar_url(me["id"])
          same_email_user.save
          update_friends(same_email_user, graph)
          render json: same_email_user
        # new user
        else
          avatar_url = fb_avatar_url(me["id"])
          user = User.new(:fb_id => me["id"],
                          :email => me["email"],
                          :name => me["name"],
                          :secret => SecureRandom.urlsafe_base64(nil, false),
                          :avatar_url => avatar_url)
          user.save
          update_friends(user, graph)
          render json: user
        end
      end
    else
      render json: { :status => :error }, :status => :bad_request
    end
  rescue => e
#    pp e
    render json: { :status => e }, :status => :bad_request
  end

private
  def fb_avatar_url(fb_id)
    "http://graph.facebook.com/#{fb_id}/picture?type=small"
  end

  def update_friends(src_user, graph)
    friends = graph.get_connections("me", "friends")
    fb_ids = friends.map {|f| f["id"] }
    users = User.find_all_by_fb_id(fb_ids)
    users.each {|u|
      begin
        friend = Friend.new(:src_user_id => src_user.id, :dest_user_id => u.id)
        friend.save
        # coming here means, it's a new friend
        push_friend_update!(u, src_user)
      rescue
      end
      begin
        friend = Friend.new(:dest_user_id => src_user.id, :src_user_id => u.id)
        friend.save
      rescue
      end
    }
  end

  def push_friend_update!(target_user, new_user)
    n = Rapns::Apns::Notification.new
    n.app = Rapns::Apns::App.find_by_name("Dochi")
    target_user.devices.each {|device|
      n.device_token = device.token
      n.alert = "#{new_user.name} started Dochi"
      n.attributes_for_device = {:user_id => new_user.id }
      n.save!
    }
  end
end
