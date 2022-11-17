class User < ApplicationRecord
  include RatingAverage

  has_secure_password

  validates :username, uniqueness: true, length: { in: 3..30 }
  validates :password, length: { minimum: 4 }, format: { with: /(?=.*\d)(?=.*[A-Z])/ }

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  def favorite_beer
    return nil if ratings.empty?

    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?

    average_scores = Beer.joins(:ratings).select("beers.*, AVG(ratings.score) as average_score").group("style")

    average_scores.max_by(&:average_score).style
  end

  def favorite_brewery
    return nil if ratings.empty?

    average_scores = Brewery.joins(:ratings).select("breweries.*, AVG(ratings.score) as average_score").group("name")

    average_scores.max_by(&:average_score).name
  end
end
