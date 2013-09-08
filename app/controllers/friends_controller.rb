class FriendsController < ApplicationController
  respond_to :json
  before_filter :_login

  def show
    respond_with(@user, :only => [:id, :name, :avatar_url], :include => [{:friends => {:only => [:id, :name, :avatar_url]}}], :location => '/hoge')
  end
  # rescue => e
  #   puts e
  #   render json: { :status => :error }, :status => :bad_request, :location => "hoge"
  # end

  def create
  end

  def update
  end

end
