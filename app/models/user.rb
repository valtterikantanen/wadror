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

  def favorite_by(ratings, criteria)
    ratings_by_criteria = ratings.group_by { |rating| rating.beer.send(criteria) }
                                 .map { |key, value| [key, value.sum(&:score) / value.size] }
    ratings_by_criteria.max_by(&:last).first
  end

  def favorite_style
    return nil if ratings.empty?

    favorite_by(ratings, :style)
  end

  def favorite_brewery
    return nil if ratings.empty?

    favorite_by(ratings, :brewery)
  end

  def self.top(n)
    sorted_by_num_of_ratings_desc = User.all.sort_by{ |u| u.ratings.count }.reverse
    sorted_by_num_of_ratings_desc[0..n-1]
  end
end
