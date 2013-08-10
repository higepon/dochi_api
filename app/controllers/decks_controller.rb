class DecksController < ApplicationController
  respond_to :html, :json
  skip_before_filter  :verify_authenticity_token
  before_filter :_login

  def index
    friends = Friend.find_all_by_src_user_id(@user.id)
    user_ids = friends.map {|f| f.dest_user_id }
    user_ids << @user.id

    @ds = Deck.find_all_by_user_id(user_ids)
    respond_with(@ds, {:only => [:id],
                       :include => [{:photos => {:only => [:id, :name], :methods => [:url]}},
                                    {:user => {:only => [:id, :name, :avatar_url]}}]})
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

  # def like
  #   deck = Deck.find(params[:deck_id])
  #   @user.like!(deck)
  #   respond_with { :ok => :ok }
  # end
end
