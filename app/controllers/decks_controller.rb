class DecksController < ApplicationController
  respond_to :html, :json
  skip_before_filter  :verify_authenticity_token

  def new
    @deck = Deck.new
  end

  def create
    @deck = Deck.new
    @deck.save
    respond_with @deck
  end

end
