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
  end
end
