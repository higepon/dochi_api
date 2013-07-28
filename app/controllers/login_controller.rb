class LoginController < ApplicationController

  def facebook
    if params[:token]
      graph = Koala::Facebook::API.new(params[:token])
      me = graph.get_object("me")
      user = User.find_by_fb_id(me["id"])
      # user has already account with facebook
      if user
        render json: user
      else
        render json: me
      end
    else
      render json: { :status => :error }, :status => :bad_request
    end
  end
end
