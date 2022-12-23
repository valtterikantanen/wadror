class Style < ApplicationRecord
  include RatingAverage

  has_many :beers
  has_many :ratings, through: :beers

  def self.top(amount)
    Style.all.sort_by(&:average_rating).reverse.first(amount)
  end

  def to_s
    name.to_s
  end
end
