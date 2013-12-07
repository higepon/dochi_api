class FriendsController < ApplicationController
  respond_to :json
  before_filter :_login

  # :location is workaround.
  def show
    respond_with(@user, :only => [:id, :name, :avatar_url], :include => [{:friends => {:only => [:id, :name, :avatar_url]}}], :location => '/')
  end

  def suggestions
    friends = @user.suggested_users # @User.find(:all, :conditions => ['id != ?', @user.id], :limit => 5, :order => "random()")
    respond_with(friends, :only => [:id, :name, :avatar_url], :location => '/')
  end

  def create
    dest = User.find(params[:dest_user_id])
    f = Friend.new
    f.src_user_id = @user.id
    f.dest_user_id = dest.id
    f.save!
    render json: { :status => :ok }
  rescue => e
    puts e
    render json: { :status => :error }, :status => :bad_request
  end
end
