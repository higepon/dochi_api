require 'spec_helper'

describe User do
  describe "#like!" do
    it "creates & returns new like model if it doesn't exist" do
      deck = Deck.first
      deck.should_not be_nil
      like = User.like!(deck)
      like.user_id.should_not be_nil
      like.deck_id.should == deck.id
    end

    it "doesn't nothing it exists" do
    end

    it "raise error if deck is not specified"
    end
  end

  describe "#unlike!" do
  end
end
