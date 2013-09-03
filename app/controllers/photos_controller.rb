require 'pp'

class PhotosController < ApplicationController
  respond_to :html, :json
  skip_before_filter  :verify_authenticity_token
  before_filter :_login
  
  def index
    @photos = Photo.all
    respond_with @photos
  end

  def new
    @photo = Photo.new
  end

  # % curl -F "photo[photo_image]=@/Users/higepon/Desktop/a.jpg" http://localhost:3000/photos.json
  def create
    @photo0 = Photo.new(params[:photo0])
    @photo0.save
    @photo1 = Photo.new(params[:photo1])
    @photo1.save
    push_to_friends!("#{@user.name} wants to check you new photos!",
                     {:deck_id => @photo0.deck_id})
    render json: { :status => :ok }
  rescue => e
    puts e
    render json: { :status => :error }, :status => :bad_request
  end

  def like
    photo = Photo.find(params[:photo_id])
    if @user.like!(photo)
      respond_with(photo,
                   {:only => [:id], :methods => [:url],
                     :include => [{:likes => {:include => {:user => {:only => [:avatar_url, :name, :id]}}, :only => [:id, :user]}}]})
    else
      @user.unlike!(photo)
      respond_with(photo.reload,
                   {:only => [:id], :methods => [:url],
                     :include => [{:likes => {:include => {:user => {:only => [:avatar_url, :name, :id]}}, :only => [:id, :user]}}]})
    end
  end

private
  def push_to_friends!(alert, attributes)
    friends = @user.friends.map {|f| User.find(f.dest_user_id) }
    devices = friends.map {|f| f.devices }.flatten
    devices.each {|d|
      n = Rapns::Apns::Notification.new
      n.app = Rapns::Apns::App.find_by_name("Dochi")
      n.device_token = d.token
      n.alert = alert
      n.attributes_for_device = attributes
      n.save!
    }
  end
end
