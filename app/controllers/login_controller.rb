class LoginController < ApplicationController

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
          render json: same_email_user
        # new user
        else
          user = User.new(:fb_id => me["id"], :email => me["email"], :name => me["name"])
          user.save
          render json: user
        end
      end
    else
      render json: { :status => :error }, :status => :bad_request
    end
  rescue => e
      render json: { :status => e }, :status => :bad_request
  end
end
