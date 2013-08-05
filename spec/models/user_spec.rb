require 'spec_helper'

describe User do
  fixtures :likes, :decks
  describe "#like!" do
    it "creates & returns new like model if it doesn't exist" do
      not_liked_yet_deck_id = 3
      deck = Deck.find(not_liked_yet_deck_id)
      deck.should_not be_nil
      
      user = User.first
      user.should_not be_nil

      like = user.like!(deck)
      like.user_id.should_not be_nil
      like.deck_id.should == deck.id
    end

    it "doesn't nothing if it exists" do
      liked_deck_id = 1
      deck = Deck.find(liked_deck_id)
      deck.should_not be_nil
      
      user = User.find(1234)
      user.should_not be_nil

      user.like!(deck).should be_nil
    end

    it "raise error if deck is not specified" do
    end
  end
  
  describe "#unlike!" do
  end
end
