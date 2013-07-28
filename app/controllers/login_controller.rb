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
        same_email_user = User.find_by_email(me["email"])
        if same_email_user
          render json: me
        else
          user = User.new(:fb_id => me["id"], :email => me["email"], :name => me["name"])
          user.save
          render json: user
        end
      end
    else
      render json: { :status => :error }, :status => :bad_request
    end
  end
end
