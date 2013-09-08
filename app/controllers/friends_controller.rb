class FriendsController < ApplicationController
  before_filter :_login
  def show
    render json: { :status => :ok }
  rescue => e
    render json: { :status => :error }, :status => :bad_request
  end
end
