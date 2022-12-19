class Style < ApplicationRecord
  include RatingAverage

  has_many :beers
  has_many :ratings, through: :beers

  def self.top(n)
    sorted_by_ratings_desc = Style.all.sort_by{ |s| s.average_rating }.reverse
    sorted_by_ratings_desc[0..n-1]
  end

  def to_s
    name.to_s
  end
end
