class FriendsController < ApplicationController
  respond_to :json
  before_filter :_login

  # :location is workaround.
  def show
    respond_with(@user, :only => [:id, :name, :avatar_url], :include => [{:friends => {:only => [:id, :name, :avatar_url]}}], :location => '/')
  end

  def suggestions
    friends = User.find(:all, :conditions => ['id != ?', @user.id], :limit => 5, :order => "rand()")
    respond_with(friends, :only => [:id, :name, :avatar_url], :location => '/')
  end
end
