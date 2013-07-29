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
    render json: { :status => :ok }
  rescue
    render json: { :status => :error }, :status => :bad_request
  end

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
