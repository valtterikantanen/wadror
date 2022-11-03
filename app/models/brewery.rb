class Brewery < ApplicationRecord
  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  def average_rating
    ratings.reduce(0){ |sum, rating| sum + rating.score }.to_f / ratings.count
  end
end
