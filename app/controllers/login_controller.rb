class LoginController < ApplicationController

  def facebook
    if params[:token]
      render json: { :name => "taro" }
    else
      render json: { :status => :error }, :status => :bad_request
    end
  end
end
