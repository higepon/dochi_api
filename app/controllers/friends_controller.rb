class FriendsController < ApplicationController
  respond_to :json
  before_filter :_login

  # :location is workaround.
  def show
    respond_with(@user, :only => [:id, :name, :avatar_url], :include => [{:friends => {:only => [:id, :name, :avatar_url]}}], :location => '/')
  end

  def suggestions
#    FUser.where(["active = 1 AND id NOT IN (?)", [3,9,23]])

    friends = @user.suggested_users # @User.find(:all, :conditions => ['id != ?', @user.id], :limit => 5, :order => "random()")
    respond_with(friends, :only => [:id, :name, :avatar_url], :location => '/')
  end
end
