class ApplicationController < ActionController::Base
  protect_from_forgery

  private
  def _login
    @user = User.find(params[:user_id]) if params[:user_id]
    if @user && @user.secret == params[:secret]
      return true
    else
      render json: { :status => :forbidden }, :status => :forbidden
    end
  end

end
