class LoginController < ApplicationController

  def facebook
    render json: { :name => "taro" }
  end

end
