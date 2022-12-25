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

  def favorite_by(criteria)
    return nil if ratings.empty?

    ratings_by_criteria = ratings.group_by { |rating| rating.beer.send(criteria) }
                                 .map { |key, value| [key, value.sum(&:score) / value.size] }
    ratings_by_criteria.max_by(&:last).first
  end

  def favorite_style
    favorite_by :style
  end

  def favorite_brewery
    favorite_by :brewery
  end

  def self.top(amount)
    User.all.sort_by{ |u| u.ratings.count }.reverse.first(amount)
  end
end
