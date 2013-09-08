class FriendsController < ApplicationController
  respond_to :json
  before_filter :_login

  # :location is workaround.
  def show
    respond_with(@user, :only => [:id, :name, :avatar_url], :include => [{:friends => {:only => [:id, :name, :avatar_url]}}], :location => '/')
  end
end
