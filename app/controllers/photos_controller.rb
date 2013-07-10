require 'pp'

class PhotosController < ApplicationController
  respond_to :html, :json
  skip_before_filter  :verify_authenticity_token

  def index
    @photos = Photo.all
    respond_with @photos
  end

  def new
    @photo = Photo.new
  end

  # % curl -F "photo[photo_image]=@/Users/higepon/Desktop/a.jpg" http://localhost:3000/photos.json
  def create
    @photo = Photo.new(params[:photo])
    @photo.save
    @photo2 = Photo.new(params[:photo2])
    @photo2.save
    render json: {:status => :ok }
  rescue
    pp "come here??"
    render json: {:status => :error }, :status => :bad_request
  end

end
