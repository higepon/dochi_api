class PhotosController < ApplicationController
  respond_to :html, :json

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
    respond_with @photo
  end

end
