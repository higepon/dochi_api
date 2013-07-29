class DecksController < ApplicationController
  respond_to :html, :json
  skip_before_filter  :verify_authenticity_token
  before_filter :_login

  def index
    @ds = Deck.all
    @decks = []
    @ds.each {|d|
      photos = []
      d.photos.each {|p|
        photo = {}
        photo[:url] = p.photo_image.thumb('320x480').url
        photos.push(photo)
      }
      deck = { :photos => photos, :user_id => d.user_id, :user_name => d.user.name }
      @decks.push(deck)
    }
    respond_with @decks
  end

  def new
    @deck = Deck.new
  end

  def create
    @deck = Deck.new
    @deck.user_id = 1234
    @deck.save
    respond_with @deck
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
