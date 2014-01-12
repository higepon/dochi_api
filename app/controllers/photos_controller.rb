require 'pp'

class PhotosController < ApplicationController
  respond_to :json
  before_filter :_login
  skip_before_filter :_login, :only => [:like_guest]
  skip_before_filter :verify_authenticity_token
  
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
    EM.defer do
      push_to_friends!("#{@user.name} wants to check you new photos!",
                       {:deck_id => @photo0.deck_id})
    end
    render json: { :status => :ok, :url => "http://dochi.monaos.org/deck/#{@photo0.deck.url_key}" }
  rescue => e
    puts e
    render json: { :status => :error }, :status => :bad_request
  end

  def like_guest
    session_id = session[:session_id]
    # dummy id for Guest user
    fb_id = "guest_" + session_id
    user = User.find_by_fb_id(fb_id)
    unless user
      user = User.new
      user.name = "Someone"
      user.fb_id = fb_id
      user.avatar_url = "/guest#{rand(8)}.png"
      user.save!
    end
    _like(user)
  end

  def like
    _like(@user)
  end

private
  def _like(user)
    photo = Photo.find(params[:photo_id])
    if user.like!(photo)
      EM.defer do
        push_liked_photo!(photo, user)
      end
      respond_with(photo,
                   {:only => [:id], :methods => [:url],
                     :include => [{:likes => {:include => {:user => {:only => [:avatar_url, :name, :id]}}, :only => [:id, :user]}}]})
    else
      user.unlike!(photo)
      respond_with(photo.reload,
                   {:only => [:id], :methods => [:url],
                     :include => [{:likes => {:include => {:user => {:only => [:avatar_url, :name, :id]}}, :only => [:id, :user]}}]})
    end
  end

  def push_liked_photo!(photo, user)
    target_user = photo.deck.user
    n = Rapns::Apns::Notification.new
    n.app = Rapns::Apns::App.find_by_name("Dochi")
    target_user.devices.each {|device|
      n.device_token = device.token
      n.alert = "#{user.name} liked your photo!"
      n.attributes_for_device = {:deck_id => photo.deck_id, :user_id => target_user.id, :type => "deck_detail" }
      n.save!
    }
    Rapns.push
  end

  def push_to_friends!(alert, attributes)
    if @photo0.deck.is_public
      devices = User.where("id != ?", @user.id) {|f| f.devices }.flatten
    else
      devices = @user.friends.map {|f| f.devices }.flatten
    end
    devices.each {|d|
      n = Rapns::Apns::Notification.new
      n.app = Rapns::Apns::App.find_by_name("Dochi")
      n.device_token = d.token
      n.alert = alert
      n.attributes_for_device = attributes
      n.save!
    }
    Rapns.push
  end
end
