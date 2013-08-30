class Deck < ActiveRecord::Base
  has_many :photos
  belongs_to :user
  include ActionView::Helpers::DateHelper
  def distance_of_created
    distance_of_time_in_words(created_at, Time.now)
  end

end
