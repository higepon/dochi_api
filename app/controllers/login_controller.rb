class LoginController < ApplicationController

  skip_before_filter  :verify_authenticity_token

  def facebook
    if params[:token]
      graph = Koala::Facebook::API.new(params[:token])
      me = graph.get_object("me")
      existing_user = User.find_by_fb_id(me["id"])
      # user has already account with facebook
      if existing_user
        render json: existing_user
      else
        # user has already account but not connected facebook
        same_email_user = User.find_by_email(me["email"])
        if same_email_user
          same_email_user.fb_id = me["id"]
          same_email_user.save
          update_friends(same_email_user, graph)
          render json: same_email_user
        # new user
        else
          user = User.new(:fb_id => me["id"], :email => me["email"], :name => me["name"], :secret =>  SecureRandom.urlsafe_base64(nil, false))
          user.save
          update_friends(user, graph)
          render json: user
        end
      end
    else
      render json: { :status => :error }, :status => :bad_request
    end
  rescue => e
    pp e
    render json: { :status => e }, :status => :bad_request
  end

private
  def update_friends(src_user, graph)
    friends = graph.get_connections("me", "friends")
    fb_ids = friends.map {|f| f["id"] }
    users = User.find_all_by_fb_id(fb_ids)
    users.each {|u|
      friend = Friend.new(:src_user_id => src_user.id, :dest_user_id => u.id)
      friend.save
    }
  end
end
