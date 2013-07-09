require 'spec_helper'

describe Deck do
  fixtures :photos, :decks

  it "should get 2 photos" do
    Deck.find(1).photos.count.should == 2
  end
end
