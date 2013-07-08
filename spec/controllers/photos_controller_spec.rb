require 'spec_helper'

describe PhotosController do

  it "should get index" do
    get 'index'
    response.should be_success
  end

end
