class LoginController < ApplicationController

  def facebook
    if params[:token]
      graph = Koala::Facebook::API.new(params[:token])
      me = graph.get_object("me")
      render json: me
    else
      render json: { :status => :error }, :status => :bad_request
    end
  end
end
