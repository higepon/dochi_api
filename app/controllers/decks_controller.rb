class DecksController < ApplicationController
  respond_to :json, :html
  skip_before_filter  :verify_authenticity_token
  before_filter :_login, :except => [:perma_link]

  def index
    friends = Friend.find_all_by_src_user_id(@user.id)
    user_ids = friends.map {|f| f.dest_user_id }
    user_ids << @user.id

    @ds = Deck.find_all_by_user_id(user_ids)
    respond_with(@ds, deck_json_format)
  end

  def show
    @deck = Deck.find(params[:id])
    respond_with(@deck, deck_json_format)
  end

  def perma_link
    @deck = Deck.find_by_url_key(params[:url_key])
    puts @deck
    respond_with(@deck, deck_json_format)
  end

  def friend
    if (@user.friends.find {|f| f.id.to_s === params[:friend_id]})
        @decks = Deck.find_all_by_user_id(params[:friend_id])
        respond_with(@decks, :only => [:id], :methods => [:distance_of_created],
                     :include => [{:photos => {:only => [:id, :name],
                                      :methods => [:url], 
                                      :include => [{:likes => {:include => {:user => {:only => [:avatar_url, :name, :id]}},
                                                       :only => [:id, :user]}}]}},
                                  {:user => {:only => [:id, :name, :avatar_url]}}], :location => '/')
    else
      render json: { :status => :error }, :status => :bad_request
    end
  end

  def new
    @deck = Deck.new
  end

  def create
    @deck = Deck.new
    @deck.user_id = @user.id
    @deck.url_key = SecureRandom.urlsafe_base64(nil, false)
    @deck.save
    respond_with @deck
  end

  private
  def deck_json_format
    {:only => [:id], :methods => [:distance_of_created],
                       :include => [{:photos => {:only => [:id, :name],
                                                 :methods => [:url], 
                                                 :include => [{:likes => {:include => {:user => {:only => [:avatar_url, :name, :id]}},
                                                               :only => [:id, :user]}}]}},
                                    {:user => {:only => [:id, :name, :avatar_url]}}]}
  end
  
end
