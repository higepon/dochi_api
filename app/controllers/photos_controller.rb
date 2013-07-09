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
    pp 'here'
    pp params
    pp "here2"
    pp params[:photo]
    @photo = Photo.new(params[:photo])
    pp "we here"
    @photo.save
    pp @photo
    respond_with @photo
  end

end
