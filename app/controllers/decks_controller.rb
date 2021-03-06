class DecksController < ApplicationController
  respond_to :html
  respond_to :json, :except => :perma_link
  skip_before_filter  :verify_authenticity_token
  before_filter :_login, :except => [:perma_link]

  def index
    friends = Friend.find_all_by_src_user_id(@user.id)
    user_ids = friends.map {|f| f.dest_user_id }
    user_ids << @user.id

    @ds = Deck.find_all_by_user_id(user_ids, :limit => 15, :order => 'created_at desc')
    @ds_public = Deck.find_all_by_is_public(true, :limit => 10, :order => 'created_at desc')
    @ds = @ds + @ds_public
    @ds.uniq! {|d| d.id }
    @ds.sort! {|a, b| b.id.to_i <=> a.id.to_i }
    respond_with(@ds, deck_json_format)
  end

  def show
    @deck = Deck.find(params[:id])
    respond_with(@deck, deck_json_format)
  end

  def perma_link
    @deck = Deck.find_by_url_key(params[:url_key])
    respond_with(@deck, deck_json_format)
  end

  def friend
    if (@user.friends.find {|f| f.id.to_s === params[:friend_id]})
        @decks = Deck.find_all_by_user_id(params[:friend_id], :limit => 20, :order => 'created_at desc')
        respond_with(@decks, :only => [:id, :caption], :methods => [:distance_of_created],
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
    @deck.is_public = (params[:is_public] == "1")
    @deck.caption = params[:caption] if params[:caption]
    @deck.save
    respond_with @deck
  end

  def delete
    @deck = Deck.find(params[:deck_id])
    if (@user.id == @deck.user_id)
      @deck.delete
      render json: { :status => :ok }
    else
      render json: { :status => :forbidden }, :status => :forbidden
    end
  end

  private
  def deck_json_format
    {:only => [:id, :caption], :methods => [:distance_of_created],
                       :include => [{:photos => {:only => [:id, :name],
                                                 :methods => [:url], 
                                                 :include => [{:likes => {:include => {:user => {:only => [:avatar_url, :name, :id]}},
                                                               :only => [:id, :user]}}]}},
                                    {:user => {:only => [:id, :name, :avatar_url]}}]}
  end
  
end
