require 'spec_helper'

describe User do
  describe "#like!" do
    fixtures :likes, :decks
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
      deck_id = 1
      user_id = 1234
      Like.where(:user_id => user_id, :deck_id => deck_id).first.should_not be_nil

      deck = Deck.find(deck_id)
      deck.should_not be_nil
      
      user = User.find(user_id)
      user.should_not be_nil

      user.like!(deck).should be_nil
    end
  end

  describe "#unlike!" do
    fixtures :likes, :decks

    it "removes like if it exists" do
      deck_id = 1
      user_id = 1234
      Like.where(:user_id => user_id, :deck_id => deck_id).first.should_not be_nil
      
      user = User.find(user_id)
      deck = Deck.find(deck_id)
      user.unlike!(deck)

      Like.where(:user_id => user_id, :deck_id => deck_id).first.should be_nil
    end

  end
end
