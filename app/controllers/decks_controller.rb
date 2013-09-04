class DecksController < ApplicationController
  respond_to :html, :json
  skip_before_filter  :verify_authenticity_token
  before_filter :_login

  def index
    friends = Friend.find_all_by_src_user_id(@user.id)
    user_ids = friends.map {|f| f.dest_user_id }
    user_ids << @user.id

    @ds = Deck.find_all_by_user_id(user_ids)
    respond_with(@ds, deck_json_format)
  end

  def show
    @deck = Deck.find(params[:deck_id])
    respond_with(@deck, deck_json_format)
  end

  def new
    @deck = Deck.new
  end

  def create
    @deck = Deck.new
    @deck.user_id = @user.id
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
